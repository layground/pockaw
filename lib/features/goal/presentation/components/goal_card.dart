import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';
import 'package:pockaw/features/goal/presentation/riverpod/checklist_items_provider.dart';

class GoalCard extends ConsumerWidget {
  final GoalModel goal;
  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        12,
      ), // Match container's border radius for ripple effect
      onTap: () {
        Log.d('🔍  Navigating to GoalDetails for goalId=${goal.id}');
        context.push(
          Routes.goalDetails,
          extra: goal.id, // <-- pass the ID along
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: AppColors.purple50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.purpleAlpha10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: AppTextStyles.body3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.purple,
                  size: 20,
                ),
              ],
            ),
            const Gap(AppSpacing.spacing16),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  padding: const EdgeInsets.all(AppSpacing.spacing4),
                  decoration: ShapeDecoration(
                    color: AppColors.purpleAlpha10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      final double progress = goal.targetAmount > 0
                          ? (goal.currentAmount / goal.targetAmount).clamp(
                              0.0,
                              1.0,
                            )
                          : 0.0;
                      return LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.purple,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusFull,
                        ),
                      );
                    },
                  ),
                ),
                const Gap(AppSpacing.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacing4,
                  ),
                  child: ref
                      .watch(checklistItemsProvider(goal.id!))
                      .when(
                        data: (checklistItems) {
                          if (checklistItems.isEmpty) {
                            return Text(
                              'No checklist items yet.',
                              style: AppTextStyles.body4.copyWith(
                                color: AppColors.neutralAlpha50,
                              ),
                            );
                          }
                          // Display up to 2 checklist items, for example
                          final itemsToShow = checklistItems.take(2).toList();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: itemsToShow.map((item) {
                              final bool isCompleted = item.completed;
                              final Color itemColor = isCompleted
                                  ? AppColors.neutralAlpha50
                                  : AppColors.purple900;
                              final IconData itemIconData = isCompleted
                                  ? HugeIcons.strokeRoundedCheckmarkCircle01
                                  : HugeIcons.strokeRoundedCircle;

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.spacing4,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      itemIconData,
                                      color: itemColor,
                                      size: 20,
                                    ),
                                    const Gap(AppSpacing.spacing4),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: AppTextStyles.body4.copyWith(
                                          color: itemColor,
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const SizedBox(
                          height: 20,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        error: (e, st) => Text(
                          'Error: $e',
                          style: AppTextStyles.body4.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
