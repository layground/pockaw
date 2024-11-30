import 'package:flutter/material.dart';
import 'package:pockaw/ui/themes/app_colors.dart';

class LoadingIndicator extends CircularProgressIndicator {
  const LoadingIndicator({
    Color color = AppColors.primary,
    double size = 16,
    double thickness = 2.4,
    Key? key,
  }) : super(
          key: key,
          strokeWidth: thickness,
          strokeCap: StrokeCap.round,
          color: color,
        );
}
