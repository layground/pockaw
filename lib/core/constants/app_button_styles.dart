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
  static ButtonStyle primaryActive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.primary600
            : AppColors.primary600,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.light
            : AppColors.light,
        shape: defaultButtonShape,
        padding: defaultButtonPadding,
      );

  static ButtonStyle primaryInactive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.primary500
            : AppColors.dark,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.primary100
            : AppColors.primary500,
        shape: defaultButtonShape,
        padding: defaultButtonPadding,
      );

  static ButtonStyle primaryOutlinedActive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.light
            : Colors.transparent,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.primary
            : AppColors.primary,
        shape: defaultButtonShape.copyWith(
          side: BorderSide(
            color: themeMode == ThemeMode.light
                ? AppColors.primary
                : AppColors.primary,
            width: AppBorders.border2,
          ),
        ),
        padding: defaultButtonPadding,
      );

  static ButtonStyle primaryOutlinedInactive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.primary100
            : Colors.transparent,
        shape: defaultButtonShape.copyWith(
          side: BorderSide(
            color: themeMode == ThemeMode.light
                ? AppColors.neutral700
                : AppColors.neutral800,
            width: AppBorders.border2,
          ),
        ),
        padding: defaultButtonPadding,
      );

  // Secondary Button Styles
  static ButtonStyle secondaryActive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.secondary600
            : AppColors.dark,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.light
            : AppColors.secondary600,
        shape: defaultButtonShape,
        padding: defaultButtonPadding,
      );

  static ButtonStyle secondaryInactive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.secondary200
            : AppColors.dark,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.secondary500
            : AppColors.secondary200,
        shape: defaultButtonShape,
        padding: defaultButtonPadding,
      );

  static ButtonStyle secondaryOutlinedActive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.neutral100
            : Colors.transparent,
        shape: defaultButtonShape.copyWith(
          side: BorderSide(
            color: themeMode == ThemeMode.light
                ? AppColors.secondary600
                : AppColors.secondary600,
            width: AppBorders.border2,
          ),
        ),
        padding: defaultButtonPadding,
      );

  static ButtonStyle secondaryOutlinedInactive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.secondary200
            : Colors.transparent,
        shape: defaultButtonShape.copyWith(
          side: BorderSide(
            color: themeMode == ThemeMode.light
                ? AppColors.neutral700
                : AppColors.neutral800,
            width: AppBorders.border2,
          ),
        ),
        padding: defaultButtonPadding,
      );

  // Tertiary Button Styles
  static ButtonStyle tertiaryActive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.tertiary600
            : AppColors.dark,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.light
            : AppColors.tertiary600,
        shape: defaultButtonShape,
        padding: defaultButtonPadding,
      );

  static ButtonStyle tertiaryInactive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.tertiary200
            : AppColors.dark,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.tertiary500
            : AppColors.tertiary200,
        shape: defaultButtonShape,
        padding: defaultButtonPadding,
      );

  static ButtonStyle tertiaryOutlinedActive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.light
            : Colors.transparent,
        shape: defaultButtonShape.copyWith(
          side: BorderSide(
            color: themeMode == ThemeMode.light
                ? AppColors.tertiary600
                : AppColors.tertiary600,
            width: AppBorders.border2,
          ),
        ),
        padding: defaultButtonPadding,
      );

  static ButtonStyle tertiaryOutlinedInactive(ThemeMode themeMode) =>
      FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: themeMode == ThemeMode.light
            ? AppColors.light
            : Colors.transparent,
        shape: defaultButtonShape.copyWith(
          side: BorderSide(
            color: themeMode == ThemeMode.light
                ? AppColors.neutral700
                : AppColors.neutral800,
            width: AppBorders.border2,
          ),
        ),
        padding: defaultButtonPadding,
      );
}
