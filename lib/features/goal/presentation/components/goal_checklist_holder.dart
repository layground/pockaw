// lib/features/goal/presentation/components/goal_checklist_holder.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_title.dart';
import 'package:pockaw/features/goal/presentation/riverpod/checklist_items_provider.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_item.dart';

class GoalChecklistHolder extends ConsumerWidget {
  final int goalId;
  const GoalChecklistHolder({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(checklistItemsProvider(goalId));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing16),
      child: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                'No checklist items yet.',
                style: AppTextStyles.body3.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }
          return Column(
            children: [
              // your title component
              const GoalChecklistTitle(),
              const Gap(AppSpacing.spacing12),
              // render each item
              ...items.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                  child: GoalChecklistItem(
                    item: entry.value,
                    isOdd: entry.key.isOdd,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
