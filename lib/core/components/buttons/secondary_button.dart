import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class SecondaryButton extends OutlinedButton {
  SecondaryButton({
    super.key,
    required super.onPressed,
    required String label,
    IconData? icon,
  }) : super(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              backgroundColor: AppColors.purple50,
              side: const BorderSide(color: AppColors.purpleAlpha10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radius8),
              ),
            ),
            child: Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: AppColors.purple,
                    size: 24,
                  ),
                const Gap(AppSpacing.spacing12),
                Text(
                  label,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.purple,
                  ),
                ),
              ],
            ));
}
