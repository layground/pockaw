import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/progress_indicators/progress_bar.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/budget/presentation/components/budget_spent_card.dart';
import 'package:pockaw/features/budget/presentation/components/budget_total_card.dart';

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing20,
      ),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.tertiary50,
        border: Border.all(color: AppColors.tertiaryAlpha25),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Text(
                'Total Remaining Budgets',
                style: AppTextStyles.body4,
              ),
              Text(
                '3.457.896',
                style: AppTextStyles.numericHeading.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const ProgressBar(value: 0.74),
          const Gap(AppSpacing.spacing12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: BudgetTotalCard()),
              Gap(AppSpacing.spacing12),
              Expanded(child: BudgetSpentCard()),
            ],
          ),
        ],
      ),
    );
  }
}
