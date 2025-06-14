// lib/features/goal/presentation/components/goal_checklist_item.dart

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/chips/custom_chip.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_checklist_form_dialog.dart';

class GoalChecklistItem extends StatelessWidget {
  final ChecklistItemModel item;
  const GoalChecklistItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        int goalId = item.goalId;
        Log.d('➕  Opening checklist dialog for goalId=$goalId');
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) =>
              GoalChecklistFormDialog(goalId: goalId, checklistItemModel: item),
        );
      },
      child: Container(
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
      ),
    );
  }
}
