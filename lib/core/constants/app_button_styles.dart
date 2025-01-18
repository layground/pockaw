import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_borders.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

class AppButtonStyles {
  static final OutlinedBorder defaultButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.radius16),
  );

  static const EdgeInsets defaultButtonPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.spacing20,
    horizontal: AppSpacing.spacing32,
  );

  // Primary Button Styles
  static final primaryActive = FilledButton.styleFrom(
    backgroundColor: AppColors.primary600,
    foregroundColor: AppColors.light,
    shape: defaultButtonShape,
    padding: defaultButtonPadding,
  );

  static final primaryInactive = FilledButton.styleFrom(
    backgroundColor: AppColors.primary500,
    foregroundColor: AppColors.primary100,
    shape: defaultButtonShape,
    padding: defaultButtonPadding,
  );

  static final primaryOutlinedActive = FilledButton.styleFrom(
    backgroundColor: AppColors.light,
    foregroundColor: AppColors.primary900,
    shape: defaultButtonShape.copyWith(
      side: const BorderSide(
          color: AppColors.primary900, width: AppBorders.border2),
    ),
    padding: defaultButtonPadding,
  );

  static final primaryOutlinedInactive = FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.blue.shade100,
    shape: defaultButtonShape.copyWith(
      side: const BorderSide(color: Colors.blue, width: AppBorders.border2),
    ),
    padding: defaultButtonPadding,
  );

  // Secondary Button Styles
  static final secondaryActive = FilledButton.styleFrom(
    backgroundColor: Colors.grey,
    foregroundColor: Colors.black,
    shape: defaultButtonShape,
    padding: defaultButtonPadding,
  );

  static final secondaryInactive = FilledButton.styleFrom(
    backgroundColor: Colors.grey.shade300,
    foregroundColor: Colors.black54,
    shape: defaultButtonShape,
    padding: defaultButtonPadding,
  );

  static final secondaryOutlinedActive = FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.grey,
    shape: defaultButtonShape.copyWith(
      side: const BorderSide(color: Colors.blue, width: AppBorders.border2),
    ),
  );

  static final secondaryOutlinedInactive = FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.grey.shade300,
    shape: defaultButtonShape.copyWith(
      side: const BorderSide(color: Colors.blue, width: AppBorders.border2),
    ),
  );

  // Tertiary Button Styles
  static final tertiaryActive = FilledButton.styleFrom(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
    shape: defaultButtonShape,
    padding: defaultButtonPadding,
  );

  static final tertiaryInactive = FilledButton.styleFrom(
    backgroundColor: Colors.orange.shade100,
    foregroundColor: Colors.white70,
    shape: defaultButtonShape,
    padding: defaultButtonPadding,
  );

  static final tertiaryOutlinedActive = FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.orange,
    shape: defaultButtonShape.copyWith(
      side: const BorderSide(color: Colors.blue, width: AppBorders.border2),
    ),
  );

  static final tertiaryOutlinedInactive = FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.orange.shade100,
    shape: defaultButtonShape.copyWith(
      side: const BorderSide(color: Colors.blue, width: AppBorders.border2),
    ),
  );
}
