import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/checklist_item_table.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';

/// Emits the list of checklist items for a given goalId
final checklistItemsProvider = StreamProvider.autoDispose
    .family<List<ChecklistItemModel>, int>((ref, goalId) {
      final db = ref.watch(databaseProvider);
      return db.checklistItemDao
          .watchChecklistItemsForGoal(goalId)
          .map((event) => event.map((e) => e.toModel()).toList());
    });
