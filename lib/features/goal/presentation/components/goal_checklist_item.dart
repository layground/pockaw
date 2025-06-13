// lib/features/goal/presentation/components/goal_checklist_item.dart

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/chips/custom_chip.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/db/app_database.dart'; // for ChecklistItem

class GoalChecklistItem extends StatelessWidget {
  final ChecklistItem item;
  const GoalChecklistItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.primaryAlpha10,
        border: Border.all(color: AppColors.primaryAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + status icon
          Row(
            children: [
              Expanded(child: Text(item.title, style: AppTextStyles.body3)),
              Icon(HugeIcons.strokeRoundedCheckmarkCircle01),
            ],
          ),
          const Gap(AppSpacing.spacing4),
          // Chips for amount and link
          Wrap(
            runSpacing: AppSpacing.spacing4,
            spacing: AppSpacing.spacing4,
            children: [
              CustomChip(
                label: 'Rp. ${item.amount?.toStringAsFixed(2)}',
                background: AppColors.tertiary100,
                foreground: AppColors.dark,
                borderColor: AppColors.tertiaryAlpha25,
              ),
              if (item.link != null && item.link!.isNotEmpty)
                CustomChip(
                  label: item.link!,
                  background: AppColors.tertiary100,
                  foreground: AppColors.dark,
                  borderColor: AppColors.tertiaryAlpha25,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
