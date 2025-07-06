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
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/services/keyboard_service/virtual_keyboard_service.dart';
import 'package:pockaw/core/services/url_launcher/url_launcher.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_checklist_form_dialog.dart';
import 'package:pockaw/features/goal/presentation/services/goal_form_service.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class GoalChecklistItem extends ConsumerWidget {
  final bool isOdd;
  final ChecklistItemModel item;
  const GoalChecklistItem({super.key, required this.item, this.isOdd = false});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.read(themeModeProvider);
    final defaultCurrency = ref
        .read(activeWalletProvider)
        .value
        ?.currencyByIsoCode(ref)
        .symbol;

    // Odd-even background
    final bgColor = isOdd
        ? context.purpleBackground(themeMode).withAlpha(50)
        : context.purpleBackground(themeMode).withAlpha(50);

    void toggle() {
      final updatedItem = item.toggleCompleted();
      GoalFormService().toggleComplete(
        context,
        ref,
        checklistItem: updatedItem,
      );
    }

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
      onDoubleTap: toggle,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.spacing8,
          horizontal: AppSpacing.spacing8,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: context.purpleBorderLighter(themeMode)),
          borderRadius: BorderRadius.circular(AppRadius.radius16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Checklist icon to the left
                IconButton(
                  icon: Icon(
                    item.completed
                        ? HugeIcons.strokeRoundedCheckmarkSquare01
                        : HugeIcons.strokeRoundedSquare,
                    color: item.completed
                        ? AppColors.green200
                        : context.secondaryText(themeMode),
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: toggle,
                  tooltip: item.completed
                      ? 'Mark as incomplete'
                      : 'Mark as complete',
                ),
                const SizedBox(width: AppSpacing.spacing8),
                // Title
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTextStyles.body4.copyWith(
                      fontWeight: item.completed
                          ? FontWeight.w400
                          : FontWeight.w500,
                      decoration: item.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Amount and link chips, right-aligned
                Gap(AppSpacing.spacing8),
                CustomChip(
                  label: '$defaultCurrency ${item.amount.toPriceFormat()}',
                  background: context.purpleBackground(themeMode),
                  foreground: context.purpleText(themeMode),
                  borderColor: context.purpleBorderLighter(themeMode),
                ),
              ],
            ),
            if (item.link.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.spacing12,
                  bottom: AppSpacing.spacing4,
                ),
                child: CustomChip(
                  label: item.link,
                  background: context.secondaryBackground(themeMode),
                  foreground: context.secondaryText(themeMode),
                  borderColor: context.secondaryBorder(themeMode),
                  onTap: () {
                    if (item.link.isLink) {
                      LinkLauncher.launch(item.link);
                    }
                  },
                  onLongPress: () {
                    KeyboardService.copyToClipboard(item.link);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
