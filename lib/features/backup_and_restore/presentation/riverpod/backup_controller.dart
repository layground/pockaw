import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service_provider.dart';
import 'package:pockaw/core/services/google/google_auth_service.dart';
import 'package:pockaw/core/services/google/google_drive_service.dart';
import 'package:pockaw/core/utils/logger.dart';

// Placeholder providers if not globally exported yet.
// Ensure these match your actual provider definitions.
// If they are defined elsewhere, you can remove these lines.
final googleAuthServiceProvider = Provider((ref) => GoogleAuthService());
final googleDriveServiceProvider = Provider(
  (ref) => GoogleDriveService(ref.read(googleAuthServiceProvider)),
);

// The main provider
final backupControllerProvider =
    NotifierProvider<BackupController, BackupState>(BackupController.new);

/// Represents the status of the backup operation
enum BackupStatus { idle, loading, success, error }

/// Represents the result of a user's choice from a dialog
enum RestoreSource { googleDrive, localFile, cancel }

/// Immutable state class for the backup screen
class BackupState {
  final BackupStatus status;
  final String message;
  final List<DriveFileSummary> driveBackups;

  const BackupState({
    this.status = BackupStatus.idle,
    this.message = '',
    this.driveBackups = const [],
  });

  BackupState copyWith({
    BackupStatus? status,
    String? message,
    List<DriveFileSummary>? driveBackups,
  }) {
    return BackupState(
      status: status ?? this.status,
      message: message ?? this.message,
      driveBackups: driveBackups ?? this.driveBackups,
    );
  }
}

class BackupController extends Notifier<BackupState> {
  late final GoogleAuthService _authService;
  late final GoogleDriveService _driveService;
  late final DataBackupService _backupService;

  @override
  BackupState build() {
    _authService = ref.read(googleAuthServiceProvider);
    _driveService = ref.read(googleDriveServiceProvider);
    _backupService = ref.read(dataBackupServiceProvider);
    return const BackupState();
  }

  // --- Drive Backup Flow ---
  Future<void> backupToDrive() async {
    state = state.copyWith(
      status: BackupStatus.loading,
      message: 'Checking permissions...',
    );

    try {
      bool hasAccess = await _authService.hasDriveAccess();
      if (!hasAccess) hasAccess = await _authService.requestDriveAccess();

      if (!hasAccess) {
        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Permission denied',
        );
        return;
      }

      state = state.copyWith(
        status: BackupStatus.loading,
        message: 'Creating local backup...',
      );
      final zip = await _backupService.createBackupZipFile();

      state = state.copyWith(
        status: BackupStatus.loading,
        message: 'Uploading to Drive...',
      );
      await _driveService.uploadBackup(zip);

      // Cleanup local file
      if (await zip.exists()) await zip.delete();

      state = state.copyWith(
        status: BackupStatus.success,
        message: 'Backup uploaded successfully!',
      );
    } catch (e, st) {
      Log.e('backupToDrive failed: $e\n$st', label: 'BackupController');
      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Backup failed: $e',
      );
    }
  }

  // --- Drive Restore Flow (Step 1: List) ---
  Future<void> fetchDriveBackups() async {
    state = state.copyWith(
      status: BackupStatus.loading,
      message: 'Searching Drive...',
    );
    try {
      // Ensure access
      bool hasAccess = await _authService.hasDriveAccess();
      if (!hasAccess) hasAccess = await _authService.requestDriveAccess();
      if (!hasAccess) {
        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Permission denied',
        );
        return;
      }

      final backups = await _driveService.searchBackups();
      if (backups.isEmpty) {
        state = state.copyWith(
          status: BackupStatus.success,
          message: 'No backups found.',
          driveBackups: [],
        );
      } else {
        state = state.copyWith(
          status: BackupStatus.idle,
          driveBackups: backups,
        ); // Ready to show list
      }
    } catch (e, st) {
      Log.e('fetchDriveBackups failed: $e\n$st', label: 'BackupController');
      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Search failed: $e',
      );
    }
  }

  // --- Drive Restore Flow (Step 2: Restore) ---
  Future<void> restoreFromDrive(String fileId) async {
    state = state.copyWith(
      status: BackupStatus.loading,
      message: 'Downloading backup...',
    );
    try {
      final file = await _driveService.downloadBackup(fileId);
      if (file == null) throw Exception('Download failed');

      state = state.copyWith(
        status: BackupStatus.loading,
        message: 'Restoring data...',
      );
      final success = await _backupService.restoreDataFromFile(file);

      if (await file.exists()) await file.delete();

      if (success) {
        state = state.copyWith(
          status: BackupStatus.success,
          message: 'Restore complete! Please restart the app.',
        );
      } else {
        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Restore process failed.',
        );
      }
    } catch (e, st) {
      Log.e('restoreFromDrive failed: $e\n$st', label: 'BackupController');
      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Restore failed: $e',
      );
    }
  }

  // --- Local Restore Flow ---
  Future<void> restoreFromLocalFile() async {
    state = state.copyWith(
      status: BackupStatus.loading,
      message: 'Waiting for file selection...',
    );
    try {
      final file = await _backupService.pickBackupZipFile();
      if (file == null) {
        state = state.copyWith(status: BackupStatus.idle); // User cancelled
        return;
      }

      state = state.copyWith(
        status: BackupStatus.loading,
        message: 'Restoring data...',
      );
      final success = await _backupService.restoreDataFromFile(file);

      if (success) {
        state = state.copyWith(
          status: BackupStatus.success,
          message: 'Restore complete!',
        );
      } else {
        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Restore failed. The backup file may be corrupt.',
        );
      }
    } catch (e, st) {
      Log.e('restoreFromLocalFile failed: $e\n$st', label: 'BackupController');
      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Restore failed.',
      );
    }
  }

  // --- Helper for UI ---
  // Since the logic for showing a dialog is UI-dependent,
  // it's often better handled in the Widget layer or via a side-effect provider/listener.
  // However, keeping this logic generic here for context.
  Future<RestoreSource> onRestoreButtonPressed() async {
    // This method is purely for the UI to call and decide what to do.
    // It doesn't change state itself, but returns a decision.
    // In a real app, you might just handle this entirely in the UI widget.
    return RestoreSource.googleDrive;
  }
}
