import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';

class BudgetFundSourceCard extends StatelessWidget {
  final BudgetModel budget;
  const BudgetFundSourceCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.light,
        border: Border.all(color: AppColors.primaryAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Row(
        children: [
          CustomIconButton(
            onPressed: () {},
            icon: HugeIcons.strokeRoundedWallet01,
            backgroundColor: AppColors.primary50,
            borderColor: AppColors.primaryAlpha25,
            color: AppColors.primary,
          ),
          const Gap(AppSpacing.spacing4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Funds Source',
                style: AppTextStyles.body3.copyWith(color: AppColors.primary),
              ),
              Text(
                budget.wallet.name, // Display wallet name
                style: AppTextStyles.body5.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
