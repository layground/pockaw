import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class BudgetTotalCard extends StatelessWidget {
  const BudgetTotalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        border: Border.all(color: AppColors.purpleAlpha25),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Budget',
            style: AppTextStyles.body5.copyWith(
              color: AppColors.purple,
            ),
          ),
          Text(
            '5.943.000',
            style: AppTextStyles.numericMedium.copyWith(
              color: AppColors.purple900,
            ),
          ),
        ],
      ),
    );
  }
}
