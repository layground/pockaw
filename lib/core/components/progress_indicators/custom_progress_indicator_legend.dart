import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class CustomProgressIndicatorLegend extends StatelessWidget {
  final String label;
  final Color color;
  const CustomProgressIndicatorLegend({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.spacing4,
      children: [
        CircleAvatar(backgroundColor: color, radius: 5),
        Text(label, style: AppTextStyles.body5),
      ],
    );
  }
}
