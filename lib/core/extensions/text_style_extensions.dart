import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_font_weights.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get semibold => copyWith(fontVariations: [AppFontWeights.semiBold]);

  TextStyle get bold => copyWith(fontVariations: [AppFontWeights.bold]);

  /// Returns a [TextStyle] with a color suitable for light mode backgrounds.
  ///
  /// This typically means a dark color.
  TextStyle toLight() {
    return copyWith(color: AppColors.neutral900); // A dark neutral color
  }

  /// Returns a [TextStyle] with a color suitable for dark mode backgrounds.
  ///
  /// This typically means a light color.
  TextStyle toDark() {
    return copyWith(color: AppColors.neutral50); // A light neutral color
  }
}
