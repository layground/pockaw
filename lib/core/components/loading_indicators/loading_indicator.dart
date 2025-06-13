import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';

class LoadingIndicator extends CircularProgressIndicator {
  const LoadingIndicator({
    Color super.color = AppColors.primary,
    double size = 16,
    double thickness = 2.4,
    super.key,
  }) : super(strokeWidth: thickness, strokeCap: StrokeCap.round);
}
