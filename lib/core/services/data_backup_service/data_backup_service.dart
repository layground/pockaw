import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:archive/archive_io.dart'; // Changed from flutter_archive
import 'package:file_picker/file_picker.dart';
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
    this._crashlytics, // Inject Crashlytics
  );

  static const String _jsonFileName = 'data.json';
  static const String _imagesDirName = 'images';
  static const String _tempBackupDirName = 'pockaw-temp-backup';
  static const String _tempRestoreDirName = 'pockaw-temp-restore';

  /// Exports all database records into a [BackupData] object.
  /// Image paths are converted to relative filenames (basenames).
  Future<BackupData> _exportDatabaseToJson() async {
    Log.i('Exporting database to JSON...');

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

    Log.i('Database export complete.');
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

  /// Imports data from a [BackupData] object into the database.
  /// Clears existing data and inserts new data in the correct order.
  Future<void> _importJsonToDatabase(BackupData data) async {
    Log.i('Importing JSON data to database...');
    await _db.clearAllTables(); // Clear all existing data

    // Insert data in dependency order
    await _db.insertAllData(
      data.users,
      data.categories,
      data.wallets,
      data.budgets,
      data.goals,
      data.checklistItems,
      data.transactions,
    );
    Log.i('JSON data import complete.');
  }

  /// Gets a clean temporary directory for backup/restore operations.
  Future<Directory> _getTempDirectory(String dirName) async {
    final tempDir = await getTemporaryDirectory();
    final backupTempDir = Directory(p.join(tempDir.path, dirName));
    if (await backupTempDir.exists()) {
      await backupTempDir.delete(recursive: true);
    }
    await backupTempDir.create(recursive: true);
    return backupTempDir;
  }

  /// Initiates the backup process.
  /// Creates a .zip file and opens the system share sheet.
  /// Returns true if successful, false otherwise.
  Future<bool> backupData() async {
    Log.i('Starting backup process...');
    Directory? tempBackupDir;

    try {
      // 1. Create a clean temporary directory for the backup
      tempBackupDir = await _getTempDirectory(_tempBackupDirName);
      final tempImagesDir = Directory(
        p.join(tempBackupDir.path, _imagesDirName),
      );
      await tempImagesDir.create(recursive: true);

      // 2. Export database to JSON (with relative image paths)
      final backupData = await _exportDatabaseToJson();
      final jsonFile = File(p.join(tempBackupDir.path, _jsonFileName));
      await jsonFile.writeAsString(jsonEncode(backupData.toJson()));
      Log.i('Database JSON saved to temporary file: ${jsonFile.path}');

      // 3. Collect and copy all original images to the temp images folder
      final List<String> originalImagePaths = [];
      for (var userMap in backupData.users) {
        // Find the original path from the DB, not the basename
        if (userMap['id'] != null) {
          final user = await _db.userDao.getUserById(userMap['id'] as int);
          if (user?.profilePicture != null) {
            originalImagePaths.add(user!.profilePicture!);
          }
        }
      }
      for (var transactionMap in backupData.transactions) {
        // Find the original path from the DB, not the basename
        if (transactionMap['id'] != null) {
          if (transactionMap['imagePath'] != null) {
            originalImagePaths.add(transactionMap['imagePath']);
          }
        }
      }

      for (String originalPath in originalImagePaths.toSet()) {
        // Use .toSet() to avoid duplicates
        final originalFile = File(originalPath);
        if (await originalFile.exists()) {
          final fileName = p.basename(originalPath);
          final destinationPath = p.join(tempImagesDir.path, fileName);
          await originalFile.copy(destinationPath);
        } else {
          Log.e(
            'Original image not found during backup: $originalPath',
            label: 'Backup Images',
          );
        }
      }
      Log.i('All images copied to temporary backup folder.');

      // 4. Zip the temporary directory
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')[0];
      final zipFileName = 'Pockaw_Backup_$timestamp.zip';
      final zipFile = File(
        p.join((await getTemporaryDirectory()).path, zipFileName),
      );

      // Use archive_io.ZipFileEncoder
      final encoder = ZipFileEncoder();
      encoder.create(zipFile.path);
      await encoder.addDirectory(tempBackupDir, includeDirName: false);
      encoder.close();

      Log.i('Backup zip file created at: ${zipFile.path}');

      // 5. Open Share dialog to save/send the zip file
      // This is the key part: no permissions needed.
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(zipFile.path)],
          subject: zipFileName,
          text: 'My Pockaw Backup File',
        ),
      );

      if (result.status == ShareResultStatus.success) {
        Log.i('Backup shared successfully.');
        return true;
      } else {
        Log.e(
          'Backup sharing was cancelled or failed: ${result.status}',
          label: 'Backup',
        );
        return false;
      }
    } catch (e, st) {
      Log.e('Backup failed: $e\n$st', label: 'Backup Error');
      // Report to Crashlytics
      await _crashlytics.log('Custom log: Pockaw Backup process failed.');
      await _crashlytics.recordError(e, st, reason: 'Backup Failed');
      return false;
    } finally {
      // 6. Clean up the temporary backup directory
      if (tempBackupDir != null && await tempBackupDir.exists()) {
        await tempBackupDir.delete(recursive: true);
      }
      Log.i('Backup cleanup complete.');
    }
  }

  /// Initiates the restore process.
  /// Asks user to pick a .zip file.
  /// Returns true if restore was successful, false otherwise.
  Future<bool> restoreData() async {
    Log.i('Starting restore process...');
    Directory? tempRestoreDir;

    try {
      // 1. Let user pick the .zip backup file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null || result.files.single.path == null) {
        Log.i('Restore cancelled by user.', label: 'Restore');
        return false;
      }

      final backupZipFile = File(result.files.single.path!);
      Log.i('Backup file picked: ${backupZipFile.path}');

      // 2. Create a clean temporary directory to unzip into
      tempRestoreDir = await _getTempDirectory(_tempRestoreDirName);

      // 3. Unzip the file
      // Use archive_io to extract
      final inputStream = InputFileStream(backupZipFile.path);
      final archive = ZipDecoder().decodeStream(inputStream);
      extractArchiveToDisk(archive, tempRestoreDir.path);
      await inputStream.close();

      Log.i('Backup file unzipped to: ${tempRestoreDir.path}');

      // 4. Verify file structure
      final jsonFile = File(p.join(tempRestoreDir.path, _jsonFileName));
      final imagesDir = Directory(p.join(tempRestoreDir.path, _imagesDirName));

      if (!await jsonFile.exists()) {
        throw Exception('Backup is invalid: "$_jsonFileName" not found.');
      }
      if (!await imagesDir.exists()) {
        Log.e(
          '"$_imagesDirName" folder not found, restoring without images.',
          label: 'Restore',
        );
        // Create it so the rest of the logic doesn't fail
        await imagesDir.create();
      }

      // 5. Read and parse data.json
      final String jsonString = await jsonFile.readAsString();
      final Map<String, dynamic> rawData = jsonDecode(jsonString);
      final BackupData backupData = BackupData.fromJson(rawData);

      // 6. Copy images from unzipped folder to app's internal image directory
      // And update the paths in backupData to point to the new location
      final appImagesDir = Directory(
        await _imageService.getAppImagesDirectory(),
      );
      if (!await appImagesDir.exists()) {
        await appImagesDir.create(recursive: true);
      }

      final Map<String, String> imagePathMap =
          {}; // Maps old basename to new full path

      await for (var entity in imagesDir.list()) {
        if (entity is File) {
          final fileName = p.basename(entity.path);
          final newPath = p.join(appImagesDir.path, fileName);
          await entity.copy(newPath);
          imagePathMap[fileName] = newPath;
        }
      }
      Log.i('Restored images copied to app storage.');

      // 7. Update all image paths in the backupData object
      for (var userMap in backupData.users) {
        final String? oldFileName = userMap['profilePicture'];
        if (oldFileName != null && imagePathMap.containsKey(oldFileName)) {
          userMap['profilePicture'] = imagePathMap[oldFileName];
        }
      }
      for (var transactionMap in backupData.transactions) {
        final String? oldFileName = transactionMap['imagePath'];
        if (oldFileName != null && imagePathMap.containsKey(oldFileName)) {
          transactionMap['imagePath'] = imagePathMap[oldFileName];
        }
      }
      Log.i('Image paths updated in backup data.');

      // 8. Import the modified data into the database
      await _importJsonToDatabase(backupData);

      Log.i('Restore process completed successfully.', label: 'Restore');
      return true;
    } catch (e, st) {
      Log.e('Restore failed: $e\n$st', label: 'Restore Error');
      // Report to Crashlytics
      await _crashlytics.log('Custom log: Pockaw Restore process failed.');
      await _crashlytics.recordError(e, st, reason: 'Restore Failed');
      return false;
    } finally {
      // 9. Clean up the temporary restore directory
      if (tempRestoreDir != null && await tempRestoreDir.exists()) {
        await tempRestoreDir.delete(recursive: true);
      }
      Log.i('Restore cleanup complete.');
    }
  }
}
