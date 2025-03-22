import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class BudgetDateCard extends StatelessWidget {
  const BudgetDateCard({super.key});

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
            icon: TablerIcons.calendar,
          ),
          const Gap(AppSpacing.spacing4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Date Range',
                style: AppTextStyles.body5.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              Text(
                '25 Jan - 24 Feb',
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
