import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class SmallButton extends ConsumerWidget {
  final String label;
  final TextStyle labelTextStyle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final GestureTapCallback? onTap;
  const SmallButton({
    super.key,
    required this.label,
    this.labelTextStyle = AppTextStyles.body4,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeModeProvider);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.spacing4,
          vertical: AppSpacing.spacing4,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.secondaryBackground(themeMode),
          border: Border.all(
            color: borderColor ?? context.secondaryBorder(themeMode),
          ),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null)
                  Icon(
                    prefixIcon,
                    size: 16,
                    color: foregroundColor ?? AppColors.secondary400,
                  ),
                const Gap(2),
                Text(
                  label,
                  style: labelTextStyle.copyWith(color: foregroundColor),
                ),
              ],
            ),
            if (suffixIcon != null) const Gap(AppSpacing.spacing8),
            if (suffixIcon != null)
              Icon(
                suffixIcon,
                size: 14,
                color: foregroundColor ?? AppColors.secondary400,
              ),
          ],
        ),
      ),
    );
  }
}
