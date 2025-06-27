import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class BudgetFundSourceCard extends ConsumerWidget {
  final BudgetModel budget;
  const BudgetFundSourceCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.read(themeModeProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: context.secondaryBackground(themeMode),
        border: Border.all(color: context.secondaryBorder(themeMode)),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Row(
        children: [
          CustomIconButton(
            onPressed: () {},
            icon: HugeIcons.strokeRoundedWallet01,
            backgroundColor: context.incomeBackground(themeMode),
            borderColor: context.incomeLine(themeMode),
            color: context.incomeText(themeMode),
          ),
          const Gap(AppSpacing.spacing4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Funds Source',
                style: AppTextStyles.body3.copyWith(
                  color: context.incomeText(themeMode),
                ),
              ),
              Text(
                budget.wallet.name, // Display wallet name
                style: AppTextStyles.body5.copyWith(
                  color: context.incomeText(themeMode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
