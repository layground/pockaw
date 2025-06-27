// lib/features/goal/presentation/components/goal_checklist_item.dart

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/chips/custom_chip.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_checklist_form_dialog.dart';
import 'package:pockaw/features/goal/presentation/services/goal_form_service.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class GoalChecklistItem extends ConsumerWidget {
  final ChecklistItemModel item;
  const GoalChecklistItem({super.key, required this.item});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.read(themeModeProvider);
    final defaultCurrency = ref
        .read(activeWalletProvider)
        .value
        ?.currencyByIsoCode(ref)
        .symbol;

    return InkWell(
      onTap: () {
        int goalId = item.goalId;
        Log.d('➕  Opening checklist dialog for goalId=$goalId');
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) =>
              GoalChecklistFormDialog(goalId: goalId, checklistItemModel: item),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: context.secondaryBackground(themeMode),
          border: Border.all(color: context.secondaryBorder(themeMode)),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status icon
            Row(
              children: [
                Expanded(child: Text(item.title, style: AppTextStyles.body3)),
                IconButton(
                  icon: Icon(
                    item.completed
                        ? HugeIcons.strokeRoundedCheckmarkCircle01
                        : HugeIcons.strokeRoundedCircle,
                    color: item.completed ? AppColors.green200 : null,
                  ),
                  onPressed: () {
                    final updatedItem = item.toggleCompleted();
                    GoalFormService().toggleComplete(
                      context,
                      ref,
                      checklistItem: updatedItem,
                    );
                  },
                ),
              ],
            ),
            const Gap(AppSpacing.spacing4),
            // Chips for amount and link
            Wrap(
              runSpacing: AppSpacing.spacing4,
              spacing: AppSpacing.spacing4,
              children: [
                CustomChip(
                  label: '$defaultCurrency ${item.amount.toPriceFormat()}',
                  background: context.secondaryBackground(themeMode),
                  foreground: context.secondaryText(themeMode),
                  borderColor: context.secondaryBorder(themeMode),
                ),
                if (item.link.isNotEmpty)
                  CustomChip(
                    label: item.link,
                    background: context.secondaryBackground(themeMode),
                    foreground: context.secondaryText(themeMode),
                    borderColor: context.secondaryBorder(themeMode),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
