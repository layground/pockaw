import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service_provider.dart';
import 'package:pockaw/core/services/google/google_auth_service.dart';
import 'package:pockaw/core/services/google/google_drive_service.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'dart:io';
import 'package:pockaw/features/user_activity/riverpod/user_activity_provider.dart';
import 'package:pockaw/features/user_activity/data/enum/user_activity_action.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';

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
  final String? localDirectory;
  final DateTime? lastLocalBackupTime;
  final DateTime? lastLocalRestoreTime;
  final String? driveDirectory;
  final DateTime? lastDriveBackupTime;
  final DateTime? lastDriveRestoreTime;
  final List<DriveFileSummary> driveBackups;

  const BackupState({
    this.status = BackupStatus.idle,
    this.message = '',
    this.localDirectory = '',
    this.lastLocalBackupTime,
    this.lastLocalRestoreTime,
    this.driveDirectory,
    this.lastDriveBackupTime,
    this.lastDriveRestoreTime,
    this.driveBackups = const [],
  });

  BackupState copyWith({
    BackupStatus? status,
    String? message,
    String? localDirectory,
    DateTime? lastLocalBackupTime,
    DateTime? lastLocalRestoreTime,
    String? driveDirectory,
    DateTime? lastDriveBackupTime,
    DateTime? lastDriveRestoreTime,
    List<DriveFileSummary>? driveBackups,
  }) {
    return BackupState(
      status: status ?? this.status,
      message: message ?? this.message,
      localDirectory: localDirectory ?? this.localDirectory,
      lastLocalBackupTime: lastLocalBackupTime ?? this.lastLocalBackupTime,
      lastLocalRestoreTime: lastLocalRestoreTime ?? this.lastLocalRestoreTime,
      driveDirectory: driveDirectory ?? this.driveDirectory,
      lastDriveBackupTime: lastDriveBackupTime ?? this.lastDriveBackupTime,
      lastDriveRestoreTime: lastDriveRestoreTime ?? this.lastDriveRestoreTime,
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
    fetchLastLocalBackupFile();
    fetchLastDriveBackupFile();
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

      state = state.copyWith(
        status: BackupStatus.success,
        message: 'Backup uploaded successfully!',
        localDirectory: basename(zip.path),
        lastLocalBackupTime: DateTime.now(),
      );

      ref
          .read(userActivityServiceProvider)
          .logActivity(
            action: UserActivityAction.cloudBackupCreated,
            metadata: basename(zip.path),
            userId: ref.read(authStateProvider).id,
          );

      // Cleanup local file
      if (await zip.exists()) await zip.delete();
    } catch (e, st) {
      Log.e('backupToDrive failed: $e\n$st', label: 'BackupController');
      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Backup failed: $e',
      );

      ref
          .read(userActivityServiceProvider)
          .logActivity(
            action: UserActivityAction.cloudBackupFailed,
            userId: ref.read(authStateProvider).id,
          );
    }
  }

  /// Create a local backup zip file and return the [File] if successful.
  /// Logs user activity on success/failure and updates state.
  Future<File?> backupLocally() async {
    state = state.copyWith(
      status: BackupStatus.loading,
      message: 'Creating local backup...',
    );

    try {
      final zip = await _backupService.createBackupZipFile();

      if (await zip.exists()) {
        state = state.copyWith(
          status: BackupStatus.success,
          message: 'Backup saved to: ${zip.path}',
          localDirectory: zip.path,
          lastLocalBackupTime: DateTime.now(),
        );

        ref
            .read(userActivityServiceProvider)
            .logActivity(
              action: UserActivityAction.backupCreated,
              metadata: zip.path,
              userId: ref.read(authStateProvider).id,
            );

        return zip;
      } else {
        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Backup failed or cancelled.',
        );

        ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.restoreFailed);
        return null;
      }
    } catch (e, st) {
      Log.e('backupLocally failed: $e\n$st', label: 'BackupController');
      await ref
          .read(userActivityServiceProvider)
          .logActivity(action: UserActivityAction.backupFailed);

      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Backup failed: $e',
      );
      return null;
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
          message: 'Found ${backups.length} backups.',
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

      if (success) {
        // Refresh active wallet
        await ref.read(activeWalletProvider.notifier).setDefaultWallet();

        state = state.copyWith(
          status: BackupStatus.success,
          message: 'Restore complete! Please restart the app.',
          lastLocalRestoreTime: DateTime.now(),
        );

        ref
            .read(userActivityServiceProvider)
            .logActivity(
              action: UserActivityAction.cloudBackupRestored,
              metadata: file.path,
              userId: ref.read(authStateProvider).id,
            );
      } else {
        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Restore process failed.',
        );

        ref
            .read(userActivityServiceProvider)
            .logActivity(
              action: UserActivityAction.cloudRestoreFailed,
              userId: ref.read(authStateProvider).id,
            );
      }

      if (await file.exists()) await file.delete();
    } catch (e, st) {
      Log.e('restoreFromDrive failed: $e\n$st', label: 'BackupController');
      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Restore failed: $e',
      );
    }
  }

  // --- Local Restore Flow ---
  /// Picks a local backup zip, restores data and applies the restored user
  /// into the auth state. Returns true on success, false otherwise.
  Future<bool> restoreFromLocalFile() async {
    state = state.copyWith(
      status: BackupStatus.loading,
      message: 'Waiting for file selection...',
    );

    try {
      final file = await _backupService.pickBackupZipFile();
      if (file == null) {
        state = state.copyWith(status: BackupStatus.idle); // User cancelled
        return false;
      }

      state = state.copyWith(
        status: BackupStatus.loading,
        message: 'Restoring data...',
      );

      final success = await _backupService.restoreDataFromFile(file);

      if (!success) {
        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Restore failed. The backup file may be corrupt.',
        );

        ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.restoreFailed);
        return false;
      }

      // After successful restore, load the first user from DB and set auth state.
      final userRow = await ref.read(userDaoProvider).getFirstUser();
      if (userRow == null) {
        // If no user after restore, treat as failure

        state = state.copyWith(
          status: BackupStatus.error,
          message: 'Restore failed.',
        );

        ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.restoreFailed);

        return false;
      }

      final userModel = userRow.toModel();
      await ref.read(authStateProvider.notifier).setUser(userModel);

      // Refresh active wallet
      await ref.read(activeWalletProvider.notifier).setDefaultWallet();

      // Small delay to let UI settle (matches previous behavior in widget)
      await Future.delayed(const Duration(milliseconds: 1500));

      state = state.copyWith(
        status: BackupStatus.success,
        message: 'Restore complete!',
        lastLocalRestoreTime: DateTime.now(),
      );

      ref
          .read(userActivityServiceProvider)
          .logActivity(action: UserActivityAction.backupRestored);

      return true;
    } catch (e, st) {
      Log.e('restoreFromLocalFile failed: $e\n$st', label: 'BackupController');

      state = state.copyWith(
        status: BackupStatus.error,
        message: 'Restore failed.',
      );

      ref
          .read(userActivityServiceProvider)
          .logActivity(action: UserActivityAction.restoreFailed);

      return false;
    }
  }

  /// Returns the configured or last-used local backup file (metadata stored
  /// in the user activity). Returns null if no information is available.
  Future<void> fetchLastLocalBackupFile() async {
    final user = ref.read(authStateProvider);
    final uid = user.id;
    if (uid == null) return;

    final dao = ref.read(userActivityDaoProvider);
    final activities = await dao.getByUserId(uid);

    final backupActionNames = {
      UserActivityAction.backupCreated.nameAsString,
      UserActivityAction.backupFailed.nameAsString,
    };

    final list = activities
        .where((a) => backupActionNames.contains(a.action))
        .toList();
    if (list.isEmpty) {
      state = state.copyWith(localDirectory: null);
      return;
    }

    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    Log.d(list.map((e) => e.toJson()).toList(), label: 'local backup list');
    final latest = list.first;
    state = state.copyWith(
      localDirectory: latest.metadata,
      lastLocalBackupTime: latest.timestamp,
    );
  }

  /// Returns the configured drive backup directory, or null if not set.
  Future<void> fetchLastDriveBackupFile() async {
    if (!(await _authService.hasDriveAccess())) return;

    final backupFile = await _driveService.getLatestBackup();
    state = state.copyWith(
      driveDirectory: backupFile?.name,
      lastDriveBackupTime: backupFile?.modifiedTime,
      driveBackups: [?backupFile],
      status: BackupStatus.idle,
    );
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
