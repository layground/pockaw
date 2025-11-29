import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
  TextStyle get black => copyWith(fontWeight: FontWeight.w900);

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
