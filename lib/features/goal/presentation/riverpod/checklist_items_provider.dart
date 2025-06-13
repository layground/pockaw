import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/core/db/database_provider.dart';

/// Emits the list of checklist items for a given goalId
final checklistItemsProvider =
    StreamProvider.autoDispose.family<List<ChecklistItem>, int>((ref, goalId) {
  final db = ref.watch(databaseProvider);
  return db.watchChecklistItemsForGoal(goalId);
});
