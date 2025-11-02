import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/services/drive_backup_service/drive_backup_service.dart';
import 'package:pockaw/core/services/image_service/image_service_provider.dart';

/// Provider for the [DriveBackupService]
final driveBackupServiceProvider = Provider<DriveBackupService>((ref) {
  return DriveBackupService(
    ref.watch(databaseProvider),
    ref.watch(imageServiceProvider),
  );
});
