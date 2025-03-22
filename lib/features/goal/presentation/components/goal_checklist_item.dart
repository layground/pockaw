import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/chips/custom_chip.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class GoalChecklistItem extends StatelessWidget {
  const GoalChecklistItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.primaryAlpha10,
        border: Border.all(color: AppColors.primaryAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Buy NVIDIA graphic card',
                  style: AppTextStyles.body3,
                ),
              ),
              Icon(TablerIcons.circle_check_filled)
            ],
          ),
          Gap(AppSpacing.spacing4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            runSpacing: AppSpacing.spacing4,
            spacing: AppSpacing.spacing4,
            children: [
              CustomChip(
                label: 'Rp. 2.455.999',
                background: AppColors.tertiary100,
                foreground: AppColors.dark,
                borderColor: AppColors.tertiaryAlpha25,
              ),
              CustomChip(
                label: 'site.com',
                background: AppColors.tertiary100,
                foreground: AppColors.dark,
                borderColor: AppColors.tertiaryAlpha25,
              ),
            ],
          )
        ],
      ),
    );
  }
}
