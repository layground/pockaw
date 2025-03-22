import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class BudgetSpentCard extends StatelessWidget {
  const BudgetSpentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: AppColors.red50,
        border: Border.all(color: AppColors.redAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spent',
            style: AppTextStyles.body5.copyWith(
              color: AppColors.red,
            ),
          ),
          Text(
            '1.233.033',
            style: AppTextStyles.numericMedium.copyWith(
              color: AppColors.red900,
            ),
          ),
        ],
      ),
    );
  }
}
