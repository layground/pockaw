// lib/features/goal/presentation/components/goal_checklist_holder.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_title.dart';
import 'package:pockaw/features/goal/presentation/riverpod/checklist_items_provider.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_item.dart';

class GoalChecklistHolder extends ConsumerWidget {
  final int goalId;
  const GoalChecklistHolder({Key? key, required this.goalId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(checklistItemsProvider(goalId));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing16),
      child: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No checklist items yet.'));
          }
          return Column(
            children: [
              // your title component
              const GoalChecklistTitle(),
              const Gap(AppSpacing.spacing12),
              // render each item
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                    child: GoalChecklistItem(item: item),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
