import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class BudgetTotalCard extends ConsumerWidget {
  final double totalAmount;
  const BudgetTotalCard({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.read(themeModeProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: context.secondaryBackground(themeMode),
        border: Border.all(color: context.secondaryBorder(themeMode)),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Budget', style: AppTextStyles.body5),
          Text(totalAmount.toPriceFormat(), style: AppTextStyles.numericMedium),
        ],
      ),
    );
  }
}
