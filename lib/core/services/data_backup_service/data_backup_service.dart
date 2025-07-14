import 'dart:convert';
import 'dart:io';

import 'package:docman/docman.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/services/data_backup_service/backup_data_model.dart';
import 'package:pockaw/core/services/image_service/image_service.dart';
import 'package:pockaw/core/utils/drift_json_converter.dart';
import 'package:pockaw/core/utils/logger.dart';

class DataBackupService {
  final AppDatabase _db;
  final ImageService _imageService;

  DataBackupService(this._db, this._imageService);

  /// Exports all database records into a [BackupData] object.
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

  /// Initiates the backup process, allowing the user to choose a destination folder.
  /// Returns the path where the backup was saved, or null if cancelled/failed.
  Future<String?> backupData() async {
    Log.i('Starting backup process...');

    // Let user pick a directory
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select a folder to save your Pockaw backup',
      lockParentWindow: true,
    );

    if (selectedDirectory == null) {
      Log.i('Backup cancelled by user.', label: 'Backup');
      return null;
    }

    try {
      final backupData = await _exportDatabaseToJson();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final backupFolderName = 'Pockaw_Backup_$timestamp';
      final backupFolderPath = p.join(selectedDirectory, backupFolderName);
      final backupDir = Directory(backupFolderPath);
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Save JSON data
      final jsonFile = File(p.join(backupFolderPath, 'data.json'));
      await jsonFile.writeAsString(jsonEncode(backupData.toJson()));
      Log.i('Database JSON saved to ${jsonFile.path}', label: 'Backup');

      // Collect and copy images
      final imagesDir = Directory(p.join(backupFolderPath, 'images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final List<String> imagePathsToCopy = [];
      // User profile picture
      for (var userMap in backupData.users) {
        if (userMap['profilePicture'] != null &&
            (userMap['profilePicture'] as String).isNotEmpty) {
          imagePathsToCopy.add(userMap['profilePicture'] as String);
        }
      }
      // Transaction images
      for (var transactionMap in backupData.transactions) {
        if (transactionMap['imagePath'] != null &&
            (transactionMap['imagePath'] as String).isNotEmpty) {
          imagePathsToCopy.add(transactionMap['imagePath'] as String);
        }
      }

      for (String originalPath in imagePathsToCopy) {
        final originalFile = File(originalPath);
        if (await originalFile.exists()) {
          final fileName = p.basename(originalPath);
          final destinationPath = p.join(imagesDir.path, fileName);
          await originalFile.copy(destinationPath);
          Log.d('Copied image: $fileName', label: 'Backup Images');
        } else {
          Log.e(
            'Original image not found: $originalPath',
            label: 'Backup Images',
          );
        }
      }

      Log.i(
        'Backup process completed successfully at $backupFolderPath',
        label: 'Backup',
      );
      return backupFolderPath;
    } catch (e, st) {
      Log.e('Backup failed: $e\n$st', label: 'Backup Error');
      return null;
    }
  }

  /// Initiates the restore process, allowing the user to select a backup folder.
  /// Returns true if restore was successful, false otherwise.
  Future<bool> restoreData() async {
    Log.i('Starting restore process...');

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select your Pockaw backup folder (containing data.json)',
      lockParentWindow: true,
    );

    if (selectedDirectory == null) {
      Log.i('Restore cancelled by user.', label: 'Restore');
      return false;
    }

    try {
      final jsonFile = File(p.join(selectedDirectory, 'data.json'));
      if (!await jsonFile.exists()) {
        Log.e(
          'data.json not found in selected folder: ${jsonFile.path}',
          label: 'Restore Error',
        );
        return false;
      }

      final String jsonString = await jsonFile.readAsString();
      final Map<String, dynamic> rawData = jsonDecode(jsonString);
      final BackupData backupData = BackupData.fromJson(rawData);

      // Copy images first and map new paths
      final appImagesDir = Directory(
        await _imageService.getAppImagesDirectory(),
      );
      if (!await appImagesDir.exists()) {
        await appImagesDir.create(recursive: true);
      }

      final backupImagesDir = Directory(p.join(selectedDirectory, 'images'));
      if (await backupImagesDir.exists()) {
        await for (var entity in backupImagesDir.list(recursive: false)) {
          if (entity is File) {
            final fileName = p.basename(entity.path);
            final newPath = p.join(appImagesDir.path, fileName);
            await entity.copy(newPath);
            Log.d(
              'Copied backup image: $fileName to $newPath',
              label: 'Restore Images',
            );
          }
        }
      }

      // Update image paths in the data before importing to DB
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

      await _importJsonToDatabase(backupData);

      Log.i('Restore process completed successfully.', label: 'Restore');
      return true;
    } catch (e, st) {
      Log.e('Restore failed: $e\n$st', label: 'Restore Error');
      return false;
    }
  }

  Future<bool> restoreDataDocman() async {
    Log.i('Starting restore process...');

    // 1. Let the user pick a directory using Docman
    // This returns a DocumentDirectory object which represents the picked directory
    final DocumentFile? selectedDocDirectory = await DocMan.pick.directory();

    if (selectedDocDirectory == null) {
      Log.i(
        'Restore cancelled by user or no directory selected.',
        label: 'Restore',
      );
      return false;
    }

    Log.d(
      'Selected directory URI: ${selectedDocDirectory.uri}',
      label: 'Restore',
    );
    Log.d(
      'Selected directory Name: ${selectedDocDirectory.name}',
      label: 'Restore',
    );

    try {
      // 2. Find and read 'data.json' from the selected directory using Docman
      final List<DocumentFile> filesInDir = await selectedDocDirectory
          .listDocuments();
      DocumentFile? jsonDocFile;

      for (var docFile in filesInDir) {
        if (docFile.name == 'data.json') {
          jsonDocFile = docFile;
          break;
        }
      }

      if (jsonDocFile == null) {
        Log.e(
          'data.json not found in selected folder: ${selectedDocDirectory.name}',
          label: 'Restore Error',
        );
        return false;
      }

      Log.d(
        'Found data.json: ${jsonDocFile.name} (URI: ${jsonDocFile.uri})',
        label: 'Restore',
      );

      // Read the content of data.json
      // Docman's DocumentFile doesn't have a direct readAsString, so read as bytes then decode
      final List<int>? jsonDataBytes = await jsonDocFile.read();
      if (jsonDataBytes == null) {
        Log.e('Failed to read data.json content.', label: 'Restore Error');
        return false;
      }
      final String jsonString = utf8.decode(
        jsonDataBytes,
      ); // Assuming UTF-8 encoding
      final Map<String, dynamic> rawData = jsonDecode(jsonString);
      final BackupData backupData = BackupData.fromJson(rawData);

      // 3. Copy images from the 'images' subdirectory in the backup to app storage
      final appImagesDirPath = await _imageService.getAppImagesDirectory();
      final appImagesDir = Directory(appImagesDirPath);
      if (!await appImagesDir.exists()) {
        await appImagesDir.create(recursive: true);
      }

      // Find the 'images' subdirectory within the selected backup directory
      DocumentFile? backupImagesDocDir;
      // Re-list or find specifically, as listFiles() on selectedDocDirectory gives files and immediate subdirs
      // A more robust way might be to look for a DocumentDirectory named 'images'
      // For simplicity, let's assume we can construct a path or list and find it.
      // Docman might not directly support navigating to subdirectories by string path easily.
      // You might need to list files/directories and find the one named 'images'.

      // Attempt 1: Iterate and find the 'images' directory
      for (var item in filesInDir) {
        // filesInDir contains DocumentFile and DocumentDirectory
        if (item.isDirectory && item.name == 'images') {
          backupImagesDocDir = item;
          break;
        }
      }

      if (backupImagesDocDir != null) {
        Log.d(
          'Found images directory: ${backupImagesDocDir.name}',
          label: 'Restore Images',
        );
        final List<DocumentFile> imageDocFiles = await backupImagesDocDir
            .listDocuments();

        for (var imageDocFile in imageDocFiles) {
          if (!(imageDocFile.name.endsWith('.png') ||
              imageDocFile.name.endsWith('.jpg') ||
              imageDocFile.name.endsWith('.jpeg'))) {
            Log.e(
              'Skipping non-image or unnamed file in backup: ${imageDocFile.name}',
              label: 'Restore Images',
            );
            continue;
          }

          final fileName = imageDocFile.name; // Should have a name
          final newPath = p.join(appImagesDir.path, fileName);

          // Read image bytes using Docman and write to app storage using dart:io
          final List<int>? imageBytes = await imageDocFile.read();
          if (imageBytes != null) {
            final newFile = File(newPath);
            await newFile.writeAsBytes(imageBytes);
            Log.d(
              'Copied backup image: $fileName to $newPath',
              label: 'Restore Images',
            );
          } else {
            Log.e(
              'Could not read bytes for image: $fileName',
              label: 'Restore Images',
            );
          }
        }
      } else {
        Log.i(
          'No "images" sub-directory found in the backup.',
          label: 'Restore Images',
        );
      }

      // 4. Update image paths in the data before importing to DB
      // This part remains the same as your original logic, using p.basename and p.join
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

      // 5. Import to database
      await _importJsonToDatabase(backupData); // Your existing method

      Log.i('Restore process completed successfully.', label: 'Restore');
      return true;
    } catch (e, st) {
      Log.e('Restore failed: $e\n$st', label: 'Restore Error');
      // If error occurs with Docman, you might want to check for plugin specific exceptions
      if (e is DocManException) {
        Log.e(
          'Docman specific error: ${e.toString()} (Code: ${e.code})',
          label: 'Docman Error',
        );
      }
      return false;
    }
  }
}
