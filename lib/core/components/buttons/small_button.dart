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
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.spacing4,
          vertical: AppSpacing.spacing4,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.secondaryAlpha10,
          border: Border.all(color: borderColor ?? AppColors.secondaryAlpha25),
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
                    color: foregroundColor ?? AppColors.secondary,
                  ),
                const Gap(2),
                Text(
                  label,
                  style: labelTextStyle.copyWith(
                    color: foregroundColor ?? AppColors.secondary,
                  ),
                ),
              ],
            ),
            if (suffixIcon != null) const Gap(AppSpacing.spacing8),
            if (suffixIcon != null)
              Icon(
                suffixIcon,
                size: 14,
                color: foregroundColor ?? AppColors.secondary,
              )
          ],
        ),
      ),
    );
  }
}
