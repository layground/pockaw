import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
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
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        border: Border.all(color: AppColors.neutralAlpha25),
      ),
      child: Column(
        spacing: AppSpacing.spacing4,
        children: [
          Text(
            title,
            style: AppTextStyles.body1.copyWith(
              color: context.cardTitleText,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.body3.copyWith(
              color: context.cardSubtitleText,
            ),
          ),
          Gap(AppSpacing.spacing16),
          Expanded(child: chart),
        ],
      ),
    );
  }
}
