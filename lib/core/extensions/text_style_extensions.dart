import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_font_weights.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(
        fontVariations: [AppFontWeights.bold],
      );
}
