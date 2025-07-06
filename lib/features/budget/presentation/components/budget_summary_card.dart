import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/progress_indicators/progress_bar.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/budget/presentation/components/budget_spent_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_total_card.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class BudgetSummaryCard extends ConsumerWidget {
  const BudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeModeProvider);
    final budgetsAsync = ref.watch(budgetListProvider);

    return budgetsAsync.when(
      data: (budgets) {
        if (budgets.isEmpty) {
          return const SizedBox.shrink(); // Or a message indicating no budgets for summary
        }

        double totalBudgetAmount = budgets.fold(
          0.0,
          (sum, budget) => sum + budget.amount,
        );
        double totalSpentAmount = 0;

        // To calculate totalSpentAmount, we need to sum up spent amounts for each budget.
        // This can be a bit tricky with async providers inside a build method for summation.
        // A more robust way would be to have another provider that calculates this summary.
        // For now, let's try a direct approach, but be mindful of performance with many budgets.
        for (final budget in budgets) {
          final spentAsync = ref.watch(budgetSpentAmountProvider(budget));
          totalSpentAmount += spentAsync.maybeWhen(
            data: (s) => s,
            orElse: () => 0,
          );
        }

        Log.d(totalSpentAmount, label: 'totalSpentAmount');

        final double totalRemainingAmount =
            totalBudgetAmount - totalSpentAmount;
        final double overallProgress =
            totalSpentAmount > 0 && totalBudgetAmount > 0
            ? (totalSpentAmount / totalBudgetAmount).clamp(0.0, 1.0)
            : 0.0;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            color: context.purpleBackground(themeMode),
            border: Border.all(color: context.purpleBorderLighter(themeMode)),
            borderRadius: BorderRadius.circular(AppRadius.radius8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Remaining Budgets',
                    style: AppTextStyles.body4,
                  ),
                  Text(
                    totalRemainingAmount.toPriceFormat(),
                    style: AppTextStyles.numericHeading.copyWith(
                      color: context.primaryText(themeMode),
                    ),
                  ),
                ],
              ),
              ProgressBar(
                value: overallProgress,
                foreground: AppColors.primary,
              ),
              const Gap(AppSpacing.spacing12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BudgetTotalCard(totalAmount: totalBudgetAmount),
                  ),
                  const Gap(AppSpacing.spacing12),
                  Expanded(
                    child: BudgetSpentCard(spentAmount: totalSpentAmount),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.spacing20),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing20),
        child: Center(child: Text('Error loading budget summary: $err')),
      ),
    );
  }
}
