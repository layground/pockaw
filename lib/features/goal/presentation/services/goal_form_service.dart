import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';
import 'package:pockaw/features/goal/presentation/riverpod/checklist_actions_provider.dart';
import 'package:pockaw/features/goal/presentation/riverpod/goals_actions_provider.dart';

class GoalFormService {
  Future<void> save(
    BuildContext context,
    WidgetRef ref, {
    required GoalModel goal,
  }) async {
    final actions = ref.read(goalsActionsProvider);
    bool isEditing = goal.id != null;
    Log.d(isEditing, label: 'isEditing');
    // return;

    if (!isEditing) {
      await actions.add(
        GoalsCompanion(
          title: Value(goal.title),
          description: Value(goal.description),
          targetAmount: Value(goal.targetAmount),
          currentAmount: Value(goal.currentAmount),
          startDate: Value(goal.startDate),
          endDate: Value(goal.endDate),
          createdAt: Value(DateTime.now()),
          iconName: Value(goal.iconName),
          associatedAccountId: Value(goal.associatedAccountId),
        ),
      );
    } else {
      await actions.update(
        Goal(
          id: goal.id ?? 0,
          title: goal.title,
          description: goal.description,
          targetAmount: goal.targetAmount,
          currentAmount: goal.currentAmount,
          startDate: goal.startDate,
          endDate: goal.endDate,
          createdAt: DateTime.now(),
          iconName: goal.iconName,
          associatedAccountId: goal.associatedAccountId,
        ),
      );
    }

    if (!context.mounted) return;
    context.pop();
  }

  Future<void> saveChecklist(
    BuildContext context,
    WidgetRef ref, {
    required ChecklistItemModel checklistItem,
  }) async {
    final actions = ref.read(checklistActionsProvider);
    bool isEditing = checklistItem.id != null;
    Log.d(isEditing, label: 'isEditing');

    if (!isEditing) {
      await actions.add(
        ChecklistItemsCompanion(
          goalId: Value(checklistItem.goalId),
          title: Value(checklistItem.title),
          amount: Value(checklistItem.amount),
          link: Value(checklistItem.link),
          completed: Value(false),
        ),
      );
    } else {
      await actions.update(
        ChecklistItem(
          id: checklistItem.id ?? 0,
          goalId: checklistItem.goalId,
          title: checklistItem.title,
          amount: checklistItem.amount,
          link: checklistItem.link,
          completed: checklistItem.completed,
        ),
      );
    }

    if (!context.mounted) return;
    context.pop();
  }

  Future<void> toggleComplete(
    BuildContext context,
    WidgetRef ref, {
    required ChecklistItemModel checklistItem,
  }) async {
    final actions = ref.read(checklistActionsProvider);
    await actions.update(
      ChecklistItem(
        id: checklistItem.id ?? 0,
        goalId: checklistItem.goalId,
        title: checklistItem.title,
        amount: checklistItem.amount,
        link: checklistItem.link,
        completed: checklistItem.completed,
      ),
    );
  }

  void deleteChecklist(
    BuildContext context,
    WidgetRef ref, {
    required ChecklistItemModel checklistItem,
  }) {
    final actions = ref.read(checklistActionsProvider);
    actions.delete(checklistItem.id ?? 0);
  }
}
