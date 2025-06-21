import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';

class BudgetDateCard extends StatelessWidget {
  final BudgetModel budget;
  const BudgetDateCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: AppColors.light,
        border: Border.all(color: AppColors.secondaryAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Row(
        children: [
          CustomIconButton(
            onPressed: () {},
            icon: HugeIcons.strokeRoundedCalendar01,
          ),
          const Gap(AppSpacing.spacing4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Budget Period',
                style: AppTextStyles.body3.copyWith(color: AppColors.secondary),
              ),
              Text(
                '${budget.startDate.toDayShortMonth()} - ${budget.endDate.toDayShortMonthYear()}',
                style: AppTextStyles.body5.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
