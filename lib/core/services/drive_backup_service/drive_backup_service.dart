import 'dart:convert';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/services/data_backup_service/backup_data_model.dart';
import 'package:pockaw/core/services/image_service/image_service.dart';
import 'package:pockaw/core/utils/logger.dart';

class DriveBackupService {
  final AppDatabase _db;
  final ImageService _imageService;
  final GoogleSignIn _googleSignIn;
  bool _isSignedIn = false;

  DriveBackupService(this._db, this._imageService)
    : _googleSignIn = GoogleSignIn.instance;

  /// Helper method to read a byte stream into a byte array
  Future<List<int>> readByteStream(Stream<List<int>> stream) async {
    final bytes = <int>[];
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  /// Signs in the user to Google Drive and returns true if successful
  Future<bool> signIn() async {
    try {
      final account = await _googleSignIn.authenticate();
      Log.i('Signed in as ${account.displayName}');
      _isSignedIn = true;
      return true;
    } catch (e, st) {
      Log.e('Google Sign In failed: $e\n$st', label: 'Drive Backup');
      return false;
    }
  }

  /// Signs out the user from Google Drive
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _isSignedIn = false;
  }

  /// Creates a folder in Google Drive and returns its ID
  Future<String?> _createFolder(
    drive.DriveApi driveApi,
    String folderName,
  ) async {
    final folder = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';

    try {
      final result = await driveApi.files.create(folder);
      return result.id;
    } catch (e) {
      Log.e('Failed to create folder: $e', label: 'Drive Backup');
      return null;
    }
  }

  /// Uploads a file to Google Drive and returns its ID
  Future<String?> _uploadFile(
    drive.DriveApi driveApi,
    String folderId,
    File file,
    String fileName,
    void Function(double)? onProgress,
  ) async {
    final driveFile = drive.File()
      ..name = fileName
      ..parents = [folderId];

    try {
      final totalLength = await file.length();
      var uploadedLength = 0;

      final media = drive.Media(
        file.openRead().map((chunk) {
          uploadedLength += chunk.length;
          if (onProgress != null) {
            onProgress(uploadedLength / totalLength);
          }
          return chunk;
        }),
        totalLength,
      );

      final result = await driveApi.files.create(driveFile, uploadMedia: media);
      return result.id;
    } catch (e) {
      Log.e('Failed to upload file: $e', label: 'Drive Backup');
      return null;
    }
  }

  /// Checks if a backup with the same name exists and returns its ID
  Future<String?> _findExistingBackup(
    drive.DriveApi driveApi,
    String folderName,
  ) async {
    try {
      final result = await driveApi.files.list(
        q: "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false",
      );
      if (result.files?.isNotEmpty == true) {
        return result.files!.first.id;
      }
    } catch (e) {
      Log.e('Failed to find existing backup: $e', label: 'Drive Backup');
    }
    return null;
  }

  /// Backup data to Google Drive
  /// Returns true if successful, false otherwise
  /// [overwriteExisting] if true, will delete the existing backup with the same name
  /// [onProgress] callback for progress updates (0.0 to 1.0)
  /// [onCancel] callback to check if operation should be cancelled
  Future<bool> backupToDrive({
    required bool overwriteExisting,
    void Function(double)? onProgress,
    bool Function()? onCancel,
  }) async {
    if (!_isSignedIn) {
      final success = await signIn();
      if (!success) return false;
    }

    try {
      final headers = await _googleSignIn.authorizationClient
          .authorizationHeaders(['https://www.googleapis.com/auth/drive']);
      final client = GoogleAuthClient(headers ?? {});
      final driveApi = drive.DriveApi(client);

      // Create backup data
      final backupData = await _db.transaction(() async {
        final users = (await _db.userDao.getAllUsers())
            .map((e) => e.toJson())
            .toList();
        final categories = (await _db.categoryDao.getAllCategories())
            .map((e) => e.toJson())
            .toList();
        final wallets = (await _db.walletDao.getAllWallets())
            .map((e) => e.toJson())
            .toList();
        final budgets = (await _db.budgetDao.getAllBudgets())
            .map((e) => e.toJson())
            .toList();
        final goals = (await _db.goalDao.getAllGoals())
            .map((e) => e.toJson())
            .toList();
        final checklistItems =
            (await _db.checklistItemDao.getAllChecklistItems())
                .map((e) => e.toJson())
                .toList();
        final transactions = (await _db.transactionDao.getAllTransactions())
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

      // Check for existing backup
      if (overwriteExisting) {
        final existingId = await _findExistingBackup(driveApi, folderName);
        if (existingId != null) {
          await driveApi.files.delete(existingId);
        }
      }

      // Create folder
      final folderId = await _createFolder(driveApi, folderName);
      if (folderId == null) return false;

      // Save JSON data
      final tempDir = await Directory.systemTemp.createTemp('pockaw_backup');
      final jsonFile = File('${tempDir.path}/data.json');
      await jsonFile.writeAsString(jsonEncode(backupData.toJson()));

      if (onCancel?.call() == true) {
        await tempDir.delete(recursive: true);
        return false;
      }

      await _uploadFile(
        driveApi,
        folderId,
        jsonFile,
        'data.json',
        (progress) => onProgress?.call(progress * 0.3), // 30% for JSON
      );

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

      // Create images folder
      final imagesFolderId = await _createFolder(
        driveApi,
        '$folderName/images',
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

          final fileName = p.basename(originalPath);
          await _uploadFile(driveApi, imagesFolderId, originalFile, fileName, (
            progress,
          ) {
            final totalProgress =
                0.3 + // JSON completed
                (0.7 * // 70% for images
                    ((completedImages + progress) / totalImages));
            onProgress?.call(totalProgress);
          });
          completedImages++;
        }
      }

      await tempDir.delete(recursive: true);
      return true;
    } catch (e, st) {
      Log.e('Drive backup failed: $e\n$st', label: 'Drive Backup');
      return false;
    }
  }

  /// Restore data from Google Drive
  /// Returns true if successful, false otherwise
  /// [onProgress] callback for progress updates (0.0 to 1.0)
  /// [onCancel] callback to check if operation should be cancelled
  Future<bool> restoreFromDrive({
    void Function(double)? onProgress,
    bool Function()? onCancel,
  }) async {
    if (!_isSignedIn) {
      final success = await signIn();
      if (!success) return false;
    }

    try {
      final headers = await _googleSignIn.authorizationClient
          .authorizationHeaders(['https://www.googleapis.com/auth/drive']);
      final client = GoogleAuthClient(headers ?? {});
      final driveApi = drive.DriveApi(client);

      // List backup folders
      final result = await driveApi.files.list(
        q: "mimeType='application/vnd.google-apps.folder' and name contains 'Pockaw_Backup_' and trashed=false",
        orderBy: 'createdTime desc',
      );

      if (result.files?.isEmpty == true) {
        Log.e('No backup found in Google Drive', label: 'Drive Restore');
        return false;
      }

      final backupFolder = result.files!.first;
      final tempDir = await Directory.systemTemp.createTemp('pockaw_restore');

      // Download data.json
      final dataJsonFiles = await driveApi.files.list(
        q: "'${backupFolder.id}' in parents and name='data.json' and trashed=false",
      );

      if (dataJsonFiles.files?.isEmpty == true) {
        Log.e('data.json not found in backup', label: 'Drive Restore');
        await tempDir.delete(recursive: true);
        return false;
      }

      if (onCancel?.call() == true) {
        await tempDir.delete(recursive: true);
        return false;
      }

      final dataJsonFile = dataJsonFiles.files!.first;
      final media =
          await driveApi.files.get(
                dataJsonFile.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final jsonFile = File('${tempDir.path}/data.json');
      await jsonFile.writeAsBytes(await readByteStream(media.stream));

      // Parse backup data
      final String jsonString = await jsonFile.readAsString();
      final Map<String, dynamic> rawData = jsonDecode(jsonString);
      final BackupData backupData = BackupData.fromJson(rawData);

      // Set up images directory
      final appImagesDir = Directory(
        await _imageService.getAppImagesDirectory(),
      );
      if (!await appImagesDir.exists()) {
        await appImagesDir.create(recursive: true);
      }

      // Get images folder
      final imagesFolders = await driveApi.files.list(
        q: "'${backupFolder.id}' in parents and name='images' and mimeType='application/vnd.google-apps.folder' and trashed=false",
      );

      if (imagesFolders.files?.isNotEmpty == true) {
        final imagesFolder = imagesFolders.files!.first;
        final imageFiles = await driveApi.files.list(
          q: "'${imagesFolder.id}' in parents and trashed=false",
        );

        var completedImages = 0;
        final totalImages = imageFiles.files?.length ?? 0;

        for (final imageFile in imageFiles.files ?? []) {
          if (onCancel?.call() == true) {
            await tempDir.delete(recursive: true);
            return false;
          }

          final media =
              await driveApi.files.get(
                    imageFile.id!,
                    downloadOptions: drive.DownloadOptions.fullMedia,
                  )
                  as drive.Media;

          final newFile = File(p.join(appImagesDir.path, imageFile.name!));
          await newFile.writeAsBytes(await readByteStream(media.stream));

          completedImages++;
          onProgress?.call(0.3 + (0.4 * (completedImages / totalImages)));
        }
      }

      // Update image paths
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

      if (onCancel?.call() == true) {
        await tempDir.delete(recursive: true);
        return false;
      }

      // Import to database
      onProgress?.call(0.7); // 70% complete
      await _db.clearAllTables();
      await _db.insertAllData(
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

/// Helper class to handle Google authentication
class GoogleAuthClient extends BaseClient {
  final Map<String, String> _headers;
  final Client _client = Client();

  GoogleAuthClient(this._headers);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
