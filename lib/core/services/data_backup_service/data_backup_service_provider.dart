import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_service_provider.dart';

/// Provides an instance of [DataBackupService].
final dataBackupServiceProvider = Provider<DataBackupService>((ref) {
  final db = ref.watch(databaseProvider);
  final imageService = ref.watch(imageServiceProvider);
  return DataBackupService(db, imageService);
});
