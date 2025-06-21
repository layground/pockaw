import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/progress_indicators/progress_bar.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_tile.dart';

class BudgetCard extends ConsumerWidget {
  final BudgetModel budget;
  const BudgetCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spentAmountAsync = ref.watch(budgetSpentAmountProvider(budget));

    final double spentAmount = spentAmountAsync.maybeWhen(
      data: (amount) => amount,
      orElse: () => 0.0, // Default to 0 if loading or error
    );
    final double remainingAmount = budget.amount - spentAmount;
    final double progress = budget.amount > 0
        ? (spentAmount / budget.amount).clamp(0.0, 1.0)
        : 0.0;

    return InkWell(
      onTap: () => context.push('${Routes.budgetDetails}/${budget.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          border: Border.all(color: AppColors.darkAlpha10),
        ),
        child: Column(
          children: [
            AbsorbPointer(
              child: CategoryTile(
                category: budget.category,
                suffixIcon: HugeIcons.strokeRoundedArrowRight01,
              ),
            ),
            const Gap(AppSpacing.spacing8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${remainingAmount.toPriceFormat()} left',
                  style: AppTextStyles.body4.copyWith(
                    color: remainingAmount < 0 ? AppColors.red : AppColors.dark,
                  ),
                ),
                Text(
                  '${spentAmount.toPriceFormat()} of ${budget.amount.toPriceFormat()}',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body4,
                ),
              ],
            ),
            const Gap(AppSpacing.spacing8),
            if (spentAmountAsync is AsyncLoading)
              const SizedBox(
                height: 4,
                child: LinearProgressIndicator(),
              ) // Small loader for progress
            else
              ProgressBar(
                value: progress,
                foreground: AppColors.primary, // Use category color
              ),
          ],
        ),
      ),
    );
  }
}
