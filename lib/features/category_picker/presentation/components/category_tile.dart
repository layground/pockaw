import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final double? height;
  final double? iconSize;
  final IconData? suffixIcon;
  final GestureTapCallback? onSuffixIconPressed;
  final String? icon;
  final GestureTapCallback? onTap;
  const CategoryTile({
    super.key,
    required this.title,
    this.onSuffixIconPressed,
    this.suffixIcon,
    this.height,
    this.iconSize = AppSpacing.spacing32,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        decoration: BoxDecoration(
          color: AppColors.secondary50,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          border: Border.all(
            color: AppColors.secondaryAlpha10,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing12),
              decoration: BoxDecoration(
                color: AppColors.secondaryAlpha10,
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                border: Border.all(
                  color: AppColors.secondaryAlpha10,
                ),
              ),
              child: Text(
                icon ?? '❓',
                style: TextStyle(
                  fontSize: iconSize,
                ),
              ),
            ),
            const Gap(AppSpacing.spacing8),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body3,
              ),
            ),
            if (suffixIcon != null)
              CustomIconButton(
                onPressed: onSuffixIconPressed ?? () {},
                iconWidget: Icon(suffixIcon!),
                iconSize: IconSize.small,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}
