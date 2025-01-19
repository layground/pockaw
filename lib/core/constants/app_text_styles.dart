import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_font_families.dart';
import 'package:pockaw/core/constants/app_font_weights.dart';

class AppTextStyles {
  static const headLine1 = TextStyle(
    fontSize: 68.0,
    fontVariations: [AppFontWeights.black],
    letterSpacing: 0.5,
    height: 1.5, // Line height
    color: AppColors.dark, // Change to your app's primary text color
  );

  static const headLine2 = TextStyle(
    fontSize: 56.0,
    fontVariations: [AppFontWeights.black],
    letterSpacing: 0.4,
    height: 1.5,
    color: AppColors.dark,
  );

  static const heading1 = TextStyle(
    fontSize: 46.0,
    fontVariations: [AppFontWeights.black],
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.dark,
  );

  static const heading2 = TextStyle(
    fontSize: 38.0,
    fontVariations: [AppFontWeights.black],
    color: AppColors.dark,
  );

  static const heading3 = TextStyle(
    fontSize: 32.0,
    fontVariations: [AppFontWeights.black],
    letterSpacing: 0.15,
    height: 1.3,
    color: AppColors.dark,
  );

  static const heading4 = TextStyle(
    fontSize: 26.0,
    fontVariations: [AppFontWeights.black],
    letterSpacing: 0.1,
    height: 1.3,
    color: AppColors.dark,
  );

  static const heading5 = TextStyle(
    fontSize: 22.0,
    fontVariations: [AppFontWeights.extraBold],
    letterSpacing: 0.05,
    height: 1.3,
    color: AppColors.dark,
  );

  static const heading6 = TextStyle(
    fontSize: 20.0,
    fontVariations: [AppFontWeights.bold],
    letterSpacing: 0.0,
    height: 1.2,
    color: AppColors.dark,
  );

  static const body1 = TextStyle(
    fontSize: 18.0,
    fontVariations: [AppFontWeights.bold],
    color: AppColors.dark,
  );

  static const body2 = TextStyle(
    fontSize: 16.0,
    fontVariations: [AppFontWeights.medium],
    color: AppColors.dark,
  );

  static const body3 = TextStyle(
    fontSize: 14.0,
    fontVariations: [AppFontWeights.medium],
    color: AppColors.dark,
  );

  static const body4 = TextStyle(
    fontSize: 12.0,
    fontVariations: [AppFontWeights.medium],
    color: AppColors.dark,
  );

  static const body5 = TextStyle(
    fontSize: 10.0,
    fontVariations: [AppFontWeights.regular],
    color: AppColors.dark,
  );

  static const numericHeading = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 36.0,
    fontVariations: [AppFontWeights.bold],
    color: AppColors.dark,
  );

  static const numericTitle = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 24.0,
    fontVariations: [AppFontWeights.bold],
    color: AppColors.dark,
  );

  static const numericLarge = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 20.0,
    fontVariations: [AppFontWeights.bold],
    color: AppColors.dark,
  );

  static const numericMedium = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 16.0,
    fontVariations: [AppFontWeights.semiBold],
    color: AppColors.dark,
  );

  static const numericRegular = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 12.0,
    fontVariations: [AppFontWeights.regular],
    color: AppColors.dark,
  );
}
