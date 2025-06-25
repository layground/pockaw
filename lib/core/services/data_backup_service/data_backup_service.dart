import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
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

    // Request storage permission (primarily for Android < 13)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        Log.e('Storage permission not granted.', label: 'Backup');
        return null;
      }
    }

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

    // Request storage permission
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        Log.e('Storage permission not granted.', label: 'Restore');
        return false;
      }
    }

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
}
