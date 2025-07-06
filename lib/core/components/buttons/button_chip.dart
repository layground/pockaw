import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class ButtonChip extends ConsumerWidget {
  final String label;
  final bool active;
  final GestureTapCallback? onTap;
  const ButtonChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.read(themeModeProvider);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      child: Container(
        decoration: BoxDecoration(
          color: active ? context.purpleBackground(themeMode) : null,
          border: Border.all(
            color: active
                ? context.purpleBorderLighter(themeMode)
                : context.purpleButtonBorder(themeMode),
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spacing8,
          AppSpacing.spacing8,
          AppSpacing.spacing12,
          AppSpacing.spacing8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              active
                  ? HugeIcons.strokeRoundedCheckmarkCircle01
                  : HugeIcons.strokeRoundedCircle,
              color: active ? context.purpleIcon(themeMode) : null,
            ),
            const Gap(AppSpacing.spacing8),
            Text(
              label,
              style: AppTextStyles.body3.copyWith(
                color: active ? context.purpleText(themeMode) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
