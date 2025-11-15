import 'dart:io';
import 'dart:convert';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/services/data_backup_service/backup_data_model.dart';
import 'package:pockaw/core/services/image_service/image_service_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/services/google/google_auth_service.dart';
import 'package:pockaw/features/user_activity/data/enum/user_activity_action.dart';
import 'package:pockaw/features/user_activity/riverpod/user_activity_provider.dart';
import 'package:toastification/toastification.dart';

/// A simple model to hold search results
class DriveFileSummary {
  final String id;
  final String name;
  final DateTime? modifiedTime;

  DriveFileSummary(this.id, this.name, this.modifiedTime);
}

class GoogleDriveService {
  final Ref _ref;

  static const String _driveApiBaseUrl = 'https://www.googleapis.com/drive/v3';
  static const String _driveUploadApiBaseUrl =
      'https://www.googleapis.com/upload/drive/v3';

  GoogleDriveService(this._ref);

  Future<Map<String, String>?> _getHeaders() =>
      _ref.read(googleAuthProvider.notifier).getAuthHeaders();

  /// Searches the user's "My Drive" for Pockaw backup files.
  Future<List<DriveFileSummary>> searchForBackupFiles() async {
    final headers = await _getHeaders();
    if (headers == null) throw Exception('Not authenticated');

    try {
      // Search for .zip files created by this app
      final query = Uri.encodeQueryComponent(
        "mimeType = 'application/zip' and name contains 'Pockaw_Backup_' and trashed=false",
      );

      // We search 'drive' (visible files), not 'appDataFolder'
      // 'spaces=drive' means it searches files created by this app.
      final url = Uri.parse(
        '$_driveApiBaseUrl/files?spaces=drive&q=$query&fields=files(id,name,modifiedTime)&orderBy=modifiedTime desc',
      );

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final files = data['files'] as List;

        final results = files.map((fileData) {
          return DriveFileSummary(
            fileData['id'] as String,
            fileData['name'] as String,
            DateTime.tryParse(fileData['modifiedTime'] ?? ''),
          );
        }).toList();

        Log.i('Found ${results.length} backup files in Drive.', label: 'Drive');
        return results;
      } else {
        throw Exception('Failed to list files: ${response.body}');
      }
    } catch (e, st) {
      Log.e('Failed to find backup file: $e\n$st', label: 'Drive Error');
      return [];
    }
  }

  /// Downloads a file from Drive and saves it to a temporary local file.
  Future<File?> downloadBackupFile(String fileId) async {
    final headers = await _getHeaders();
    if (headers == null) return null;

    try {
      final url = Uri.parse('$_driveApiBaseUrl/files/$fileId?alt=media');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        // Use a unique name for the downloaded file to avoid conflicts
        final localFile = File(
          p.join(tempDir.path, 'drive_restore_$fileId.zip'),
        );
        await localFile.writeAsBytes(response.bodyBytes);

        Log.i('Backup file downloaded to: ${localFile.path}', label: 'Drive');
        return localFile;
      } else {
        throw Exception('Failed to download file: ${response.body}');
      }
    } catch (e, st) {
      Log.e('Failed to download backup file: $e\n$st', label: 'Drive Error');
      return null;
    }
  }

  /// Uploads a local backup file to Google Drive.
  /// This will always CREATE a new file in the user's "My Drive" root.
  Future<void> uploadBackupFile(
    File localFile, {
    String? parentId,
    String? mimeType,
  }) async {
    final headers = await _getHeaders();
    if (headers == null) return;

    try {
      final fileLength = await localFile.length();
      final backupFileName = p.basename(localFile.path);

      // --- 1. Initiate Resumable Create ---
      final initUrl = Uri.parse(
        '$_driveUploadApiBaseUrl/files?uploadType=resumable',
      );
      final createHeaders = {
        ...headers,
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final metadata = <String, dynamic>{
        'name': backupFileName,
        'mimeType': mimeType ?? 'application/zip',
      };
      if (parentId != null) metadata['parents'] = [parentId];

      final body = json.encode(metadata);

      final initResponse = await http.post(
        initUrl,
        headers: createHeaders,
        body: body,
      );

      if (initResponse.statusCode != 200) {
        throw Exception('Failed to initiate create: ${initResponse.body}');
      }
      final uploadUrl = initResponse.headers['location']!;

      // --- 2. Upload Bytes (PUT) ---
      final uploadHeaders = {
        'Content-Length': fileLength.toString(),
      };

      final fileBytes = await localFile.readAsBytes();
      // Ensure content type is set based on provided mimeType
      final uploadHeadersWithType = {
        ...uploadHeaders,
        'Content-Type': mimeType ?? 'application/zip',
      };

      final uploadResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: uploadHeadersWithType,
        body: fileBytes,
      );

      if (uploadResponse.statusCode == 200) {
        Log.i('Successfully uploaded backup file to Drive.', label: 'Drive');
      } else {
        throw Exception('Failed to upload bytes: ${uploadResponse.body}');
      }
    } catch (e, st) {
      Log.e('Failed to upload backup file: $e\n$st', label: 'Drive Error');
      // Force sign out on permissions error via the auth notifier
      _ref.read(googleAuthProvider.notifier).signOut();
      rethrow;
    }
  }

  /// Backup data to Google Drive
  /// Returns true if successful, false otherwise
  Future<bool> backupToDrive({
    required bool overwriteExisting,
    void Function(double)? onProgress,
    bool Function()? onCancel,
  }) async {
    final headers = await _getHeaders();
    if (headers == null) return false;

    try {
      final db = _ref.read(databaseProvider);

      // Create backup data
      final backupData = await db.transaction(() async {
        final users = (await db.userDao.getAllUsers())
            .map((e) => e.toJson())
            .toList();
        final categories = (await db.categoryDao.getAllCategories())
            .map((e) => e.toJson())
            .toList();
        final wallets = (await db.walletDao.getAllWallets())
            .map((e) => e.toJson())
            .toList();
        final budgets = (await db.budgetDao.getAllBudgets())
            .map((e) => e.toJson())
            .toList();
        final goals = (await db.goalDao.getAllGoals())
            .map((e) => e.toJson())
            .toList();
        final checklistItems =
            (await db.checklistItemDao.getAllChecklistItems())
                .map((e) => e.toJson())
                .toList();
        final transactions = (await db.transactionDao.getAllTransactions())
            .map((e) => e.toJson())
            .toList();

        return BackupData(
          users: users,
          categories: categories,
          wallets: wallets,
          budgets: budgets,
          goals: goals,
          checklistItems: checklistItems,
          transactions: transactions,
        );
      });

      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final folderName = 'Pockaw_Backup_$timestamp';

      // Ensure we have a top-level parent folder for all backups called
      // "Pockaw Backup". Create it if it doesn't exist, then create the
      // timestamped backup folder inside it.
      const topLevelBackupFolderName = 'Pockaw Backup';
      String? topLevelFolderId = await _findFolderIdByName(
        topLevelBackupFolderName,
        headers,
      );

      topLevelFolderId ??= await _createFolderHttp(
        topLevelBackupFolderName,
        headers,
      );

      // Optionally delete existing backups with same name
      if (overwriteExisting) {
        final existingId = await _findExistingBackupId(folderName, headers);
        if (existingId != null) {
          await http.delete(
            Uri.parse('$_driveApiBaseUrl/files/$existingId'),
            headers: headers,
          );
        }
      }

      // Create timestamped backup folder inside the top-level backup folder
      final folderId = await _createFolderHttp(
        folderName,
        headers,
        parentId: topLevelFolderId,
      );
      if (folderId == null) return false;

      // Save JSON data to temp file
      final tempDir = await Directory.systemTemp.createTemp('pockaw_backup');
      final jsonFile = File('${tempDir.path}/data.json');
      await jsonFile.writeAsString(json.encode(backupData.toJson()));

      if (onCancel?.call() == true) {
        await tempDir.delete(recursive: true);
        return false;
      }

      // Upload JSON into the created folder
      await uploadBackupFile(
        jsonFile,
        parentId: folderId,
        mimeType: 'application/json',
      );
      onProgress?.call(0.3);

      // Upload images
      final List<String> imagePathsToCopy = [];
      for (var userMap in backupData.users) {
        if (userMap['profilePicture'] != null &&
            (userMap['profilePicture'] as String).isNotEmpty) {
          imagePathsToCopy.add(userMap['profilePicture'] as String);
        }
      }
      for (var transactionMap in backupData.transactions) {
        if (transactionMap['imagePath'] != null &&
            (transactionMap['imagePath'] as String).isNotEmpty) {
          imagePathsToCopy.add(transactionMap['imagePath'] as String);
        }
      }

      // Create images folder as a child of the backup folder
      final imagesFolderId = await _createFolderHttp(
        'images',
        headers,
        parentId: folderId,
      );
      if (imagesFolderId == null) return false;

      if (onCancel?.call() == true) {
        await tempDir.delete(recursive: true);
        return false;
      }

      var completedImages = 0;
      final totalImages = imagePathsToCopy.length;

      for (String originalPath in imagePathsToCopy) {
        final originalFile = File(originalPath);
        if (await originalFile.exists()) {
          if (onCancel?.call() == true) {
            await tempDir.delete(recursive: true);
            return false;
          }

          await uploadBackupFile(
            originalFile,
            parentId: imagesFolderId,
            mimeType: _mimeTypeForFile(originalPath),
          );

          completedImages++;
          final totalProgress =
              0.3 +
              (0.7 * (completedImages / (totalImages == 0 ? 1 : totalImages)));
          onProgress?.call(totalProgress);
        }
      }

      await tempDir.delete(recursive: true);
      return true;
    } catch (e, st) {
      Log.e('Drive backup failed: $e\n$st', label: 'Drive Backup');
      return false;
    }
  }

  Future<String?> _createFolderHttp(
    String folderName,
    Map<String, String> headers, {
    String? parentId,
  }) async {
    try {
      final url = Uri.parse('$_driveApiBaseUrl/files');
      final bodyMap = <String, dynamic>{
        'name': folderName,
        'mimeType': 'application/vnd.google-apps.folder',
      };
      if (parentId != null) bodyMap['parents'] = [parentId];
      final body = json.encode(bodyMap);
      final createHeaders = {
        ...headers,
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final res = await http.post(url, headers: createHeaders, body: body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        return data['id'] as String?;
      }
    } catch (e, st) {
      Log.e('Create folder failed: $e\n$st', label: 'Drive Error');
    }
    return null;
  }

  String _mimeTypeForFile(String path) {
    final ext = p.extension(path).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }

  Future<String?> _findExistingBackupId(
    String folderName,
    Map<String, String> headers,
  ) async {
    try {
      final q = Uri.encodeQueryComponent(
        "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false",
      );
      final url = Uri.parse('$_driveApiBaseUrl/files?q=$q&fields=files(id)');
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final files = data['files'] as List?;
        if (files != null && files.isNotEmpty) {
          return files.first['id'] as String?;
        }
      }
    } catch (e, st) {
      Log.e('Find existing backup failed: $e\n$st', label: 'Drive Error');
    }
    return null;
  }

  /// Find a folder ID by name. If [parentId] is provided, the search will be
  /// restricted to that parent folder; otherwise the entire drive is searched.
  Future<String?> _findFolderIdByName(
    String name,
    Map<String, String> headers, {
    String? parentId,
  }) async {
    try {
      final qBase =
          "mimeType='application/vnd.google-apps.folder' and name='$name' and trashed=false";
      final q = parentId == null
          ? Uri.encodeQueryComponent(qBase)
          : Uri.encodeQueryComponent("$qBase and '$parentId' in parents");
      final url = Uri.parse('$_driveApiBaseUrl/files?q=$q&fields=files(id)');
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final files = data['files'] as List?;
        if (files != null && files.isNotEmpty) {
          return files.first['id'] as String?;
        }
      }
    } catch (e, st) {
      Log.e('Find folder failed: $e\n$st', label: 'Drive Error');
    }
    return null;
  }

  /// Restore data from Google Drive
  Future<bool> restoreFromDrive({
    void Function(double)? onProgress,
    bool Function()? onCancel,
  }) async {
    final headers = await _getHeaders();
    if (headers == null) return false;

    try {
      // List backup folders
      final q = Uri.encodeQueryComponent(
        "mimeType='application/vnd.google-apps.folder' and name contains 'Pockaw_Backup_' and trashed=false",
      );
      final url = Uri.parse(
        '$_driveApiBaseUrl/files?q=$q&orderBy=createdTime desc&fields=files(id,name)',
      );
      final res = await http.get(url, headers: headers);
      if (res.statusCode != 200) {
        Log.e(
          'Failed to list backup folders: ${res.body}',
          label: 'Drive Restore',
        );
        return false;
      }

      final data = json.decode(res.body) as Map<String, dynamic>;
      final files = data['files'] as List?;
      if (files == null || files.isEmpty) {
        Log.e('No backup found in Google Drive', label: 'Drive Restore');
        return false;
      }

      final backupFolder = files.first;
      final tempDir = await Directory.systemTemp.createTemp('pockaw_restore');

      // Download data.json
      // The Drive REST doesn't support nested 'files' path like this; instead use files.list with q param
      final listUrl = Uri.parse(
        '$_driveApiBaseUrl/files?q=${Uri.encodeQueryComponent("'${backupFolder['id']}' in parents and name='data.json' and trashed=false")}',
      );
      final listRes = await http.get(listUrl, headers: headers);
      if (listRes.statusCode != 200) {
        Log.e(
          'Failed to list data.json: ${listRes.body}',
          label: 'Drive Restore',
        );
        await tempDir.delete(recursive: true);
        return false;
      }

      final listData = json.decode(listRes.body) as Map<String, dynamic>;
      final dataFiles = listData['files'] as List?;
      if (dataFiles == null || dataFiles.isEmpty) {
        Log.e('data.json not found in backup', label: 'Drive Restore');
        await tempDir.delete(recursive: true);
        return false;
      }

      final dataJsonFile = dataFiles.first;
      final mediaUrl = Uri.parse(
        '$_driveApiBaseUrl/files/${dataJsonFile['id']}?alt=media',
      );
      final mediaRes = await http.get(mediaUrl, headers: headers);
      if (mediaRes.statusCode != 200) {
        Log.e(
          'Failed to download data.json: ${mediaRes.body}',
          label: 'Drive Restore',
        );
        await tempDir.delete(recursive: true);
        return false;
      }

      final jsonFile = File('${tempDir.path}/data.json');
      await jsonFile.writeAsBytes(mediaRes.bodyBytes);

      final String jsonString = await jsonFile.readAsString();
      final Map<String, dynamic> rawData =
          json.decode(jsonString) as Map<String, dynamic>;
      final BackupData backupData = BackupData.fromJson(rawData);

      // Prepare images directory
      final imageService = _ref.read(imageServiceProvider);
      final appImagesDir = Directory(
        await imageService.getAppImagesDirectory(),
      );
      if (!await appImagesDir.exists()) {
        await appImagesDir.create(recursive: true);
      }

      // List image files in folder
      final imagesListUrl = Uri.parse(
        '$_driveApiBaseUrl/files?q=${Uri.encodeQueryComponent("'${backupFolder['id']}' in parents and trashed=false")}',
      );
      final imagesListRes = await http.get(imagesListUrl, headers: headers);
      if (imagesListRes.statusCode == 200) {
        final imagesListData =
            json.decode(imagesListRes.body) as Map<String, dynamic>;
        final imageFiles = imagesListData['files'] as List?;

        for (final imageFile in imageFiles ?? []) {
          if (onCancel?.call() == true) {
            await tempDir.delete(recursive: true);
            return false;
          }

          final fileRes = await http.get(
            Uri.parse('$_driveApiBaseUrl/files/${imageFile['id']}?alt=media'),
            headers: headers,
          );
          if (fileRes.statusCode == 200) {
            final newFile = File(
              p.join(appImagesDir.path, imageFile['name'] ?? ''),
            );
            await newFile.writeAsBytes(fileRes.bodyBytes);
          }
        }
      }

      // Map image paths
      for (var userMap in backupData.users) {
        if (userMap['profilePicture'] != null &&
            (userMap['profilePicture'] as String).isNotEmpty) {
          final oldFileName = p.basename(userMap['profilePicture'] as String);
          userMap['profilePicture'] = p.join(appImagesDir.path, oldFileName);
        }
      }
      for (var transactionMap in backupData.transactions) {
        if (transactionMap['imagePath'] != null &&
            (transactionMap['imagePath'] as String).isNotEmpty) {
          final oldFileName = p.basename(transactionMap['imagePath'] as String);
          transactionMap['imagePath'] = p.join(appImagesDir.path, oldFileName);
        }
      }

      // Import to database
      final db = _ref.read(databaseProvider);
      onProgress?.call(0.7);
      await db.clearAllTables();
      await db.insertAllData(
        backupData.users,
        backupData.categories,
        backupData.wallets,
        backupData.budgets,
        backupData.goals,
        backupData.checklistItems,
        backupData.transactions,
      );

      await tempDir.delete(recursive: true);
      onProgress?.call(1.0);
      return true;
    } catch (e, st) {
      Log.e('Drive restore failed: $e\n$st', label: 'Drive Restore');
      return false;
    }
  }
}

/// Riverpod provider for the GoogleDriveService.
///
/// This provider uses the compatibility `GoogleAuthService` facade so we don't
/// have to migrate every consumer at once. If you prefer we can migrate
/// `GoogleDriveService` to accept the `GoogleAuthNotifier` instead and create
/// the service from `ref.read(googleAuthProvider.notifier)`.
final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  return GoogleDriveService(ref);
});

// ---------------------------------------------------------------------------
// Drive backup UI-facing notifier (moved here from drive_backup_provider.dart)
// ---------------------------------------------------------------------------

class DriveBackupState {
  final bool isLoading;
  final double progress;
  final String? error;

  DriveBackupState({this.isLoading = false, this.progress = 0.0, this.error});

  DriveBackupState copyWith({
    bool? isLoading,
    double? progress,
    String? error,
  }) {
    return DriveBackupState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }
}

/// Drive backup controller that wraps `GoogleDriveService` and auth.
class DriveBackupNotifier extends Notifier<DriveBackupState> {
  @override
  DriveBackupState build() => DriveBackupState();

  void cancelOperation() {
    // No-op for now; implementations may respect cancellation callbacks.
  }

  Future<GoogleSignInAccount?> lightweightAuthentication() async {
    return ref.read(googleAuthProvider);
  }

  Future<bool> backupToDrive({bool overwriteExisting = false}) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, progress: 0.0, error: null);

    try {
      // Ensure the user is signed in. If not, open the sign-in flow.
      if (ref.read(googleAuthProvider) == null) {
        await ref.read(googleAuthProvider.notifier).signIn();
      }

      // Ensure Drive scopes are granted before proceeding by attempting to
      // obtain auth headers. If headers are null, request scopes and retry.
      var headers = await ref
          .read(googleAuthProvider.notifier)
          .getAuthHeaders();

      if (headers == null) {
        final granted = await ref
            .read(googleAuthProvider.notifier)
            .requestDriveAccess();

        Log.i(
          'Drive permission granted: $granted',
          label: 'Drive Backup',
        );

        if (!granted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Drive permission not granted',
          );
          return false;
        }

        headers = await ref.read(googleAuthProvider.notifier).getAuthHeaders();
        Log.i(
          'Drive headers after requesting access: $headers',
          label: 'Drive Backup',
        );

        if (headers == null) {
          state = state.copyWith(
            isLoading: false,
            error: 'Drive permission required',
          );
          Toast.show(
            'Drive permission required',
            type: ToastificationType.error,
          );
          return false;
        }
      }

      final service = ref.read(googleDriveServiceProvider);
      final success = await service.backupToDrive(
        overwriteExisting: overwriteExisting,
        onProgress: (p) => state = state.copyWith(progress: p),
        onCancel: () => false,
      );

      if (!success) {
        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.cloudBackupFailed);

        state = state.copyWith(isLoading: false, error: 'Backup failed.');
        Toast.show('Backup failed.', type: ToastificationType.error);
        return false;
      } else {
        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.cloudBackupCreated);
      }

      state = state.copyWith(isLoading: false, progress: 1.0);
      Toast.show(
        'Backup completed successfully.',
        type: ToastificationType.success,
      );
      return true;
    } catch (e, st) {
      await ref
          .read(userActivityServiceProvider)
          .logActivity(
            action: UserActivityAction.cloudBackupFailed,
            metadata: '$e',
          );

      Log.e('Drive backup failed: $e\n$st', label: 'Drive Backup');
      state = state.copyWith(isLoading: false, error: e.toString());
      Toast.show('Backup error', type: ToastificationType.error);
      return false;
    }
  }

  Future<bool> restoreFromDrive() async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, progress: 0.0, error: null);

    try {
      // Ensure the user is signed in. If not, open the sign-in flow.
      if (ref.read(googleAuthProvider) == null) {
        await ref.read(googleAuthProvider.notifier).signIn();
      }

      // Ensure Drive scopes are granted before proceeding by attempting to
      // obtain auth headers. If headers are null, request scopes and retry.
      var headers = await ref
          .read(googleAuthProvider.notifier)
          .getAuthHeaders();

      if (headers == null) {
        final granted = await ref
            .read(googleAuthProvider.notifier)
            .requestDriveAccess();

        if (!granted) {
          state = state.copyWith(
            isLoading: false,
            error: 'Drive permission required',
          );
          return false;
        }

        headers = await ref.read(googleAuthProvider.notifier).getAuthHeaders();

        if (headers == null) {
          state = state.copyWith(
            isLoading: false,
            error: 'Drive permission required',
          );
          Toast.show(
            'Drive permission required',
            type: ToastificationType.error,
          );
          return false;
        }
      }

      final service = ref.read(googleDriveServiceProvider);
      final success = await service.restoreFromDrive(
        onProgress: (p) => state = state.copyWith(progress: p),
        onCancel: () => false,
      );

      if (!success) {
        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.cloudRestoreFailed);
        state = state.copyWith(isLoading: false, error: 'Restore failed.');
        Toast.show('Restore failed.', type: ToastificationType.error);
        return false;
      } else {
        await ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.cloudBackupRestored);
      }

      state = state.copyWith(isLoading: false, progress: 1.0);
      Toast.show(
        'Restore completed successfully.',
        type: ToastificationType.success,
      );
      return true;
    } catch (e, st) {
      await ref
          .read(userActivityServiceProvider)
          .logActivity(
            action: UserActivityAction.cloudRestoreFailed,
            metadata: '$e',
          );
      Log.e('Drive restore failed: $e\n$st', label: 'Drive Restore');
      state = state.copyWith(isLoading: false, error: e.toString());
      Toast.show('Restore failed', type: ToastificationType.error);
      return false;
    }
  }
}

final driveBackupProvider =
    NotifierProvider<DriveBackupNotifier, DriveBackupState>(
      DriveBackupNotifier.new,
    );
