import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class ChartContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget chart;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  const ChartContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.chart,
    this.margin,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: context.purpleBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        spacing: AppSpacing.spacing4,
        children: [
          Text(
            title,
            style: AppTextStyles.heading6.copyWith(
              color: context.cardTitleText,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.body3.copyWith(
              color: context.cardSubtitleText,
            ),
          ),
          Expanded(child: chart),
        ],
      ),
    );
  }
}
