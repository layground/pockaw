import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color? background;
  final Color? foreground;
  final Color? borderColor;
  final IconData? icon;
  final Color? iconColor;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  const CustomChip({
    super.key,
    required this.label,
    this.background,
    this.foreground,
    this.icon,
    this.iconColor,
    this.borderColor,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing8,
          vertical: AppSpacing.spacing4,
        ),
        decoration: BoxDecoration(
          color: background ?? AppColors.primary50,
          borderRadius: BorderRadius.circular(AppRadius.radiusFull),
          border: borderColor == null ? null : Border.all(color: borderColor!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: 14, color: iconColor ?? AppColors.primary50),
            if (icon != null) const Gap(AppSpacing.spacing2),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.body4.copyWith(
                  color: foreground ?? AppColors.primary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
