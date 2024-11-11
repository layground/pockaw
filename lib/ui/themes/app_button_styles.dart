import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary500,
    textStyle: AppTextStyles.buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.standard),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: AppSpacing.standard,
      horizontal: AppSpacing.medium,
    ),
  );

  static final ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.sky,
    textStyle: AppTextStyles.buttonText.copyWith(color: AppColors.gray900),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.standard),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: AppSpacing.standard,
      horizontal: AppSpacing.medium,
    ),
  );

  static final ButtonStyle warningButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.amber,
    textStyle: AppTextStyles.buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.standard),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: AppSpacing.standard,
      horizontal: AppSpacing.medium,
    ),
  );
}
