import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/progress_indicators/progress_bar.dart';
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
      borderRadius: BorderRadius.circular(AppRadius.radius12),
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
          color: context.purpleBackground,
          borderRadius: BorderRadius.circular(AppRadius.radius12),
          border: Border.all(color: context.purpleBorderLighter),
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
                    style: AppTextStyles.body3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, size: 20),
              ],
            ),
            const Gap(AppSpacing.spacing16),
            // This entire section's content (progress bar + checklist preview)
            // will now be determined by the state of checklistItemsProvider.
            ref
                .watch(checklistItemsProvider(goal.id!))
                .when(
                  data: (checklistItems) {
                    final int totalItems = checklistItems.length;
                    final int completedItems = checklistItems
                        .where((item) => item.completed)
                        .length;
                    final double progress = totalItems > 0
                        ? (completedItems / totalItems).toDouble()
                        : 0.0;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProgressBar(value: progress),
                        const Gap(AppSpacing.spacing8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.spacing4,
                          ),
                          child: checklistItems.isEmpty
                              ? Text(
                                  'No checklist items yet.',
                                  style: AppTextStyles.body4.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: checklistItems.take(2).map((item) {
                                    final bool isCompleted = item.completed;
                                    final Color itemColor = isCompleted
                                        ? context.disabledText
                                        : context.purpleText;
                                    final List<List<dynamic>> itemIconData =
                                        isCompleted
                                        ? HugeIcons
                                              .strokeRoundedCheckmarkCircle01
                                        : HugeIcons.strokeRoundedCircle;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.spacing4,
                                      ),
                                      child: Row(
                                        children: [
                                          HugeIcon(
                                            icon: itemIconData,
                                            color: itemColor,
                                            size: 20,
                                          ),
                                          const Gap(AppSpacing.spacing4),
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: AppTextStyles.body4
                                                  .copyWith(
                                                    color: itemColor,
                                                    decoration: isCompleted
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingStateForChecklistSection(),
                  error: (e, st) =>
                      _buildErrorStateForChecklistSection(e.toString()),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingStateForChecklistSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          child: LinearProgressIndicator(
            value: null, // Indeterminate
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation(AppColors.purple),
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
          ),
        ),
        const Gap(AppSpacing.spacing8),
        const SizedBox(
          height: 40, // Adjusted for potential two lines of text loading
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorStateForChecklistSection(String error) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          child: LinearProgressIndicator(
            value: 0.0, // Show 0% on error
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation(AppColors.purple),
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
          ),
        ),
        const Gap(AppSpacing.spacing8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
          child: Text(
            'Error loading checklist.', // Simplified error message
            style: AppTextStyles.body4.copyWith(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
