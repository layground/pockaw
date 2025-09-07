import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';

class BudgetSpentCard extends StatelessWidget {
  final double spentAmount;
  const BudgetSpentCard({super.key, required this.spentAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: context.expenseBackground,
        border: Border.all(color: context.expenseLine),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spent',
            style: AppTextStyles.body5.copyWith(
              color: context.expenseText,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(spentAmount.toPriceFormat(), style: AppTextStyles.numericMedium),
        ],
      ),
    );
  }
}
