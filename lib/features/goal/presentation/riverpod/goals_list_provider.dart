import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/core/db/database_provider.dart';  // your existing singleton

/// Emits a new list of all Goal rows whenever the table changes
final goalsListProvider = StreamProvider.autoDispose<List<Goal>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllGoals();
});
