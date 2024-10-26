import 'package:flutter/material.dart';

TextStyle _defaultTextStyle = const TextStyle(fontSize: 24);

extension TextExtensions on BuildContext {
  TextStyle get textDisplayLarge =>
      Theme.of(this).textTheme.displayLarge ?? _defaultTextStyle;

  TextStyle get textDisplayMedium =>
      Theme.of(this).textTheme.displayMedium ?? _defaultTextStyle;

  TextStyle get textDisplaySmall =>
      Theme.of(this).textTheme.displaySmall ?? _defaultTextStyle;

  TextStyle get textHeadlineLarge =>
      Theme.of(this).textTheme.headlineLarge ?? _defaultTextStyle;

  TextStyle get textHeadlineMedium =>
      Theme.of(this).textTheme.headlineMedium ?? _defaultTextStyle;

  TextStyle get textHeadlineSmall =>
      Theme.of(this).textTheme.headlineSmall ?? _defaultTextStyle;

  TextStyle get textTitleLarge =>
      Theme.of(this).textTheme.titleLarge ?? _defaultTextStyle;

  TextStyle get textTitleMedium =>
      Theme.of(this).textTheme.titleMedium ?? _defaultTextStyle;

  TextStyle get textTitleSmall =>
      Theme.of(this).textTheme.titleSmall ?? _defaultTextStyle;

  TextStyle get textBodyLarge =>
      Theme.of(this).textTheme.bodyLarge ?? _defaultTextStyle;

  TextStyle get textBodyMedium =>
      Theme.of(this).textTheme.bodyMedium ?? _defaultTextStyle;

  TextStyle get textBodySmall =>
      Theme.of(this).textTheme.bodySmall ?? _defaultTextStyle;

  TextStyle get textLabelLarge =>
      Theme.of(this).textTheme.labelLarge ?? _defaultTextStyle;

  TextStyle get textLabelMedium =>
      Theme.of(this).textTheme.labelMedium ?? _defaultTextStyle;

  TextStyle get textLabelSmall =>
      Theme.of(this).textTheme.labelSmall ?? _defaultTextStyle;
}
