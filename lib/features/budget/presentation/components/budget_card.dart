import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/progress_indicators/progress_bar.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_tile.dart';
import 'package:pockaw/core/db/app_database.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  const BudgetCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(AppRadius.radius8),
        border: Border.all(color: AppColors.darkAlpha10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                budget.name,
                style:
                    AppTextStyles.body3.copyWith(fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text(budget.timeline),
                backgroundColor: AppColors.purple50,
              ),
            ],
          ),
          const Gap(AppSpacing.spacing8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount',
                style: AppTextStyles.body4,
              ),
              Text(
                budget.amount.toStringAsFixed(2),
                textAlign: TextAlign.right,
                style: AppTextStyles.body4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
