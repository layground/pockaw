import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/checklist_item_table.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';

enum GoalChecklistSort {
  none,
  titleAsc,
  titleDesc,
  priceAsc,
  priceDesc,
  completed,
}

/// Emits the list of checklist items for a given goalId
final checklistItemsProvider = StreamProvider.autoDispose
    .family<List<ChecklistItemModel>, int>((ref, goalId) {
      final db = ref.watch(databaseProvider);
      return db.checklistItemDao
          .watchChecklistItemsForGoal(goalId)
          .map((items) {
            final sort = ref.watch(goalChecklistSortProvider);
            switch (sort) {
              case GoalChecklistSort.titleAsc:
                items.sort((a, b) => a.title.compareTo(b.title));
                break;
              case GoalChecklistSort.titleDesc:
                items.sort((a, b) => b.title.compareTo(a.title));
                break;
              case GoalChecklistSort.priceAsc:
                items.sort(
                  (a, b) =>
                      a.amount == null ? 0 : a.amount!.compareTo(b.amount!),
                );
                break;
              case GoalChecklistSort.priceDesc:
                items.sort(
                  (a, b) =>
                      b.amount == null ? 0 : b.amount!.compareTo(a.amount!),
                );
                break;
              case GoalChecklistSort.completed:
                items.sort(
                  (a, b) => a.completed != null && !a.completed! ? 1 : -1,
                );
                break;
              case GoalChecklistSort.none:
                // No sorting
                break;
            }
            return items;
          })
          .map((event) => event.map((e) => e.toModel()).toList());
    });

// create goalChecklistSortProvider notifier
class GoalChecklistNotifier extends Notifier<GoalChecklistSort> {
  @override
  GoalChecklistSort build() {
    return GoalChecklistSort.titleAsc;
  }

  void setSort(GoalChecklistSort sort) {
    state = sort;
  }
}

final goalChecklistSortProvider =
    NotifierProvider.autoDispose<GoalChecklistNotifier, GoalChecklistSort>(
      GoalChecklistNotifier.new,
    );
