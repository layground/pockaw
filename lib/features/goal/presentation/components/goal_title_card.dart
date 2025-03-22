import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class GoalTitleCard extends StatelessWidget {
  const GoalTitleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.spacing20),
      decoration: BoxDecoration(
        color: AppColors.secondary50,
        border: Border.all(color: AppColors.secondaryAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '12 November 2024 - 1 February 2024',
            style: AppTextStyles.body5,
          ),
          Text(
            'Build my dream PC',
            style: AppTextStyles.body2,
          ),
        ],
      ),
    );
  }
}
