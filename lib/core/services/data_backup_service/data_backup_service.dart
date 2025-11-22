import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/services/data_backup_service/backup_data_model.dart';
import 'package:pockaw/core/services/image_service/image_service.dart';
import 'package:pockaw/core/utils/drift_json_converter.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:share_plus/share_plus.dart';

class DataBackupService {
  final AppDatabase _db;
  final ImageService _imageService;
  final FirebaseCrashlytics _crashlytics;

  DataBackupService(
    this._db,
    this._imageService,
    this._crashlytics,
  );

  static const String _jsonFileName = 'data.json';
  static const String _imagesDirName = 'images';
  static const String _defaultBackupDirectory = '/storage/emulated/0/Documents';
  static const String _backupDir = 'PockawBackup';
  // static const String _tempBackupDirName = 'pockaw-temp-backup';
  static const String _tempRestoreDirName = 'pockaw-temp-restore';

  // ---------------------------------------------------------------------------
  // PUBLIC METHODS (Called by Controllers)
  // ---------------------------------------------------------------------------

  /// 1. Create ZIP File
  /// Creates a temporary folder, exports JSON + images, zips it, and returns the file.
  Future<File> createBackupZipFile({
    bool deleteImageBackupDirectory = false,
    bool deleteDataBackupFile = false,
    bool deleteBackupZipFile = true,
  }) async {
    Log.i('Creating backup ZIP file...', label: 'Backup');
    Directory? tempBackupDir;

    try {
      // A. Prepare temp directory
      tempBackupDir = await _getDefaultDirectory();
      final tempImagesDir = Directory(
        p.join(tempBackupDir.path, _imagesDirName),
      );
      await tempImagesDir.create(recursive: true);

      // B. Export data to JSON
      final backupData = await _exportDatabaseToJson();
      final jsonFile = File(p.join(tempBackupDir.path, _jsonFileName));
      await jsonFile.writeAsString(jsonEncode(backupData.toJson()));

      // C. Copy images to temp directory
      final allImagePaths = await _getAllImagePaths(backupData);
      for (final originalPath in allImagePaths) {
        final originalFile = File(originalPath);
        if (await originalFile.exists()) {
          final fileName = p.basename(originalPath);
          final destinationPath = p.join(tempImagesDir.path, fileName);
          await originalFile.copy(destinationPath);
        }
      }

      // D. Create ZIP archive
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')[0];
      final zipFileName = 'Pockaw_Backup_$timestamp.zip';
      final zipFile = File(
        p.join(tempBackupDir.path, zipFileName),
      );

      final encoder = ZipFileEncoder();
      encoder.create(zipFile.path);
      await encoder.addDirectory(tempBackupDir, includeDirName: false);
      encoder.close();

      if (deleteImageBackupDirectory) {
        tempImagesDir.delete(recursive: true);
      }

      if (deleteDataBackupFile) {
        jsonFile.delete();
      }

      Log.i('Backup ZIP created at: ${zipFile.path}', label: 'Backup');
      return zipFile;
    } catch (e, st) {
      Log.e('Failed to create backup zip: $e\n$st', label: 'Backup Error');
      rethrow;
    } finally {
      // Cleanup temp folder (but keep the zip file)
      if (deleteBackupZipFile &&
          tempBackupDir != null &&
          await tempBackupDir.exists()) {
        await tempBackupDir.delete(recursive: true);
      }
    }
  }

  /// 2. Pick Backup Zip
  /// Opens the file picker for the user to select a zip file.
  Future<File?> pickBackupZipFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e, st) {
      Log.e('Failed to pick backup file: $e\n$st', label: 'Restore Error');
      return null;
    }
  }

  /// 3. Restore Data From File
  /// Takes a ZIP file, extracts it, and imports data + images.
  Future<bool> restoreDataFromFile(File zipFile) async {
    Log.i('Restoring from ZIP: ${zipFile.path}', label: 'Restore');
    Directory? tempRestoreDir;

    try {
      // A. Prepare temp directory
      tempRestoreDir = await _getTempDirectory(_tempRestoreDirName);

      // B. Unzip
      final inputStream = InputFileStream(zipFile.path);
      final archive = ZipDecoder().decodeStream(inputStream);
      await extractArchiveToDisk(archive, tempRestoreDir.path);
      await inputStream.close();

      // C. Verify Structure
      final jsonFile = File(p.join(tempRestoreDir.path, _jsonFileName));
      final imagesDir = Directory(p.join(tempRestoreDir.path, _imagesDirName));

      if (!await jsonFile.exists()) {
        throw Exception('Invalid backup: $_jsonFileName missing');
      }
      // Create images dir if missing (e.g. backup had no images)
      if (!await imagesDir.exists()) {
        await imagesDir.create();
      }

      // D. Read Data
      final jsonString = await jsonFile.readAsString();
      final rawData = jsonDecode(jsonString);
      final backupData = BackupData.fromJson(rawData);

      // E. Restore Images
      final appImagesDir = Directory(
        await _imageService.getAppImagesDirectory(),
      );
      if (!await appImagesDir.exists()) {
        await appImagesDir.create(recursive: true);
      }

      final pathMap =
          <String, String>{}; // Map old filename -> new absolute path

      await for (var entity in imagesDir.list()) {
        if (entity is File) {
          final fileName = p.basename(entity.path);
          final newPath = p.join(appImagesDir.path, fileName);
          await entity.copy(newPath);
          pathMap[fileName] = newPath;
        }
      }

      // F. Update paths in data & Import
      _updateBackupDataPaths(backupData, pathMap);
      await _importJsonToDatabase(backupData);

      Log.i('Restore completed successfully.', label: 'Restore');
      return true;
    } catch (e, st) {
      Log.e('Restore failed: $e\n$st', label: 'Restore Error');
      await _crashlytics.recordError(e, st, reason: 'Restore Failed');
      return false;
    } finally {
      // Cleanup
      if (tempRestoreDir != null && await tempRestoreDir.exists()) {
        await tempRestoreDir.delete(recursive: true);
      }
    }
  }

  /// 4. Offline Backup & Share (Legacy/Manual)
  /// Wraps createBackupZipFile and shares it via system share sheet.
  Future<bool> backupDataToLocalAndShare() async {
    try {
      final zipFile = await createBackupZipFile();

      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(zipFile.path, mimeType: 'application/zip')],
          text: 'Pockaw Backup',
        ),
      );

      if (result.status == ShareResultStatus.success) {
        return true;
      }
      return false;
    } catch (e, st) {
      Log.e('Offline backup failed: $e\n$st', label: 'Backup Error');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // PRIVATE HELPERS
  // ---------------------------------------------------------------------------

  /// Perform file picker to select directory
  Future<Directory> _getDefaultDirectory() async {
    try {
      /// declare default internal android directory path
      final String defaultDirectory = Platform.isAndroid
          ? _defaultBackupDirectory
          : (await getApplicationDocumentsDirectory()).path;

      final backupDirectory = Directory(p.join(defaultDirectory, _backupDir));
      Log.d(backupDirectory, label: 'Selected Directory');

      return backupDirectory;
    } catch (e, st) {
      Log.e('Failed to pick directory: $e\n$st', label: 'Backup Error');

      final String defaultDirectory =
          (await getApplicationDocumentsDirectory()).path;
      final backupDirectory = Directory(p.join(defaultDirectory, _backupDir));

      return backupDirectory;
    }
  }

  Future<Directory> _getTempDirectory(String dirName) async {
    final tempDir = await getTemporaryDirectory();
    final backupTempDir = Directory(p.join(tempDir.path, dirName));
    if (await backupTempDir.exists()) {
      await backupTempDir.delete(recursive: true);
    }
    await backupTempDir.create(recursive: true);
    return backupTempDir;
  }

  Future<BackupData> _exportDatabaseToJson() async {
    final users = (await _db.userDao.getAllUsers())
        .map((e) => e.toMap())
        .toList();
    final categories = (await _db.categoryDao.getAllCategories())
        .map((e) => e.toMap())
        .toList();
    final wallets = (await _db.walletDao.getAllWallets())
        .map((e) => e.toMap())
        .toList();
    final budgets = (await _db.budgetDao.getAllBudgets())
        .map((e) => e.toMap())
        .toList();
    final goals = (await _db.goalDao.getAllGoals())
        .map((e) => e.toMap())
        .toList();
    final checklistItems = (await _db.checklistItemDao.getAllChecklistItems())
        .map((e) => e.toMap())
        .toList();
    final transactions = (await _db.transactionDao.getAllTransactions())
        .map((e) => e.toMap())
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
  }

  Future<void> _importJsonToDatabase(BackupData data) async {
    await _db.clearAllTables();
    await _db.insertAllData(
      data.users,
      data.categories,
      data.wallets,
      data.budgets,
      data.goals,
      data.checklistItems,
      data.transactions,
    );
  }

  Future<Set<String>> _getAllImagePaths(BackupData backupData) async {
    final imagePaths = <String>{};

    // User profile pictures
    for (var userMap in backupData.users) {
      if (userMap['id'] != null) {
        // Fetch fresh from DB to ensure we get correct path if simple ID reference
        // Or if 'profilePicture' is already in the map:
        final path = userMap['profilePicture'] as String?;
        if (path != null && path.isNotEmpty) {
          imagePaths.add(path);
        }
      }
    }

    // Transaction images
    for (var txMap in backupData.transactions) {
      final path = txMap['imagePath'] as String?;
      if (path != null && path.isNotEmpty) {
        imagePaths.add(path);
      }
    }
    return imagePaths;
  }

  void _updateBackupDataPaths(
    BackupData backupData,
    Map<String, String> pathMap,
  ) {
    // Update Users
    for (var userMap in backupData.users) {
      final oldPath = userMap['profilePicture'] as String?;
      if (oldPath != null && oldPath.isNotEmpty) {
        final oldName = p.basename(oldPath);
        if (pathMap.containsKey(oldName)) {
          userMap['profilePicture'] = pathMap[oldName];
        }
      }
    }
    // Update Transactions
    for (var txMap in backupData.transactions) {
      final oldPath = txMap['imagePath'] as String?;
      if (oldPath != null && oldPath.isNotEmpty) {
        final oldName = p.basename(oldPath);
        if (pathMap.containsKey(oldName)) {
          txMap['imagePath'] = pathMap[oldName];
        }
      }
    }
  }
}
