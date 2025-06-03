import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/core/db/database_provider.dart';

/// Emits a new list of checklist items for a specific goal whenever the table changes
final checklistListProvider = StreamProvider.autoDispose.family<List<ChecklistItem>, int>((ref, goalId) {
  final db = ref.watch(databaseProvider);
  return db.watchChecklistItemsForGoal(goalId);
}); 