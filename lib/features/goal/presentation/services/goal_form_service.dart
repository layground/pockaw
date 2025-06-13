import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';
import 'package:pockaw/features/goal/presentation/riverpod/checklist_actions_provider.dart';
import 'package:pockaw/features/goal/presentation/riverpod/goals_actions_provider.dart';

class GoalFormService {
  Future<void> save(BuildContext context, WidgetRef ref, GoalModel goal) async {
    final actions = ref.read(goalsActionsProvider);

    await actions.add(
      GoalsCompanion(
        title: Value(goal.title),
        note: Value('${goal.description}'),
        startDate: Value(goal.createdAt),
        endDate: Value(goal.deadlineDate ?? DateTime.now()),
      ),
    );

    if (!context.mounted) return;
    context.pop();
  }

  Future<void> saveChecklist(
    BuildContext context,
    WidgetRef ref,
    ChecklistItemModel checklistItem,
  ) async {
    final actions = ref.read(checklistActionsProvider);
    await actions.add(
      ChecklistItemsCompanion(
        goalId: Value(checklistItem.id ?? 1),
        title: Value(checklistItem.title),
        amount: Value(checklistItem.amount),
        link: Value(checklistItem.link),
      ),
    );

    if (!context.mounted) return;
    context.pop();
  }
}
