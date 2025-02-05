import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class WalletSwitcherDropdown extends StatelessWidget {
  const WalletSwitcherDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.spacing4,
          vertical: AppSpacing.spacing4,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondaryAlpha10,
          border: Border.all(color: AppColors.secondaryAlpha25),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  TablerIcons.wallet,
                  size: 16,
                  color: AppColors.secondary,
                ),
                const Gap(2),
                Text(
                  'E-Wallet',
                  style: AppTextStyles.body4.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.spacing8),
            const Icon(
              TablerIcons.chevron_down,
              size: 14,
              color: AppColors.secondary,
            )
          ],
        ),
      ),
    );
  }
}
