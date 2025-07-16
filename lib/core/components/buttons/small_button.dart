import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class SmallButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.radius8),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.spacing4,
          vertical: AppSpacing.spacing4,
        ),
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              context.secondaryButtonBackground(context.themeMode),
          border: Border.all(
            color: borderColor ?? context.secondaryBorder(context.themeMode),
          ),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.spacing4,
              children: [
                if (prefixIcon != null)
                  Icon(
                    prefixIcon,
                    size: 16,
                    color: foregroundColor ?? AppColors.secondary400,
                  ),
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
