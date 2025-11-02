import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/services/drive_backup_service/drive_backup_service.dart';
import 'package:pockaw/core/services/drive_backup_service/drive_backup_service_provider.dart';
import 'package:pockaw/core/utils/logger.dart';

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

class DriveBackupNotifier extends StateNotifier<DriveBackupState> {
  final DriveBackupService _driveBackupService;
  bool _shouldCancel = false;

  DriveBackupNotifier(this._driveBackupService) : super(DriveBackupState());

  void cancelOperation() {
    _shouldCancel = true;
  }

  Future<bool> backupToDrive({required bool overwriteExisting}) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, progress: 0.0, error: null);
    _shouldCancel = false;

    try {
      final success = await _driveBackupService.backupToDrive(
        overwriteExisting: overwriteExisting,
        onProgress: (progress) {
          state = state.copyWith(progress: progress);
        },
        onCancel: () => _shouldCancel,
      );

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          error: 'Backup failed. Please try again.',
        );
        return false;
      }

      state = state.copyWith(isLoading: false, progress: 1.0);
      return true;
    } catch (e, st) {
      Log.e('Drive backup failed: $e\n$st', label: 'Drive Backup');
      state = state.copyWith(
        isLoading: false,
        error: 'Backup failed: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> restoreFromDrive() async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, progress: 0.0, error: null);
    _shouldCancel = false;

    try {
      final success = await _driveBackupService.restoreFromDrive(
        onProgress: (progress) {
          state = state.copyWith(progress: progress);
        },
        onCancel: () => _shouldCancel,
      );

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          error: 'Restore failed. Please try again.',
        );
        return false;
      }

      state = state.copyWith(isLoading: false, progress: 1.0);
      return true;
    } catch (e, st) {
      Log.e('Drive restore failed: $e\n$st', label: 'Drive Restore');
      state = state.copyWith(
        isLoading: false,
        error: 'Restore failed: ${e.toString()}',
      );
      return false;
    }
  }
}

final driveBackupProvider =
    StateNotifierProvider<DriveBackupNotifier, DriveBackupState>((ref) {
      return DriveBackupNotifier(ref.watch(driveBackupServiceProvider));
    });
