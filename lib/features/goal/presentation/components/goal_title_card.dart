import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';

class GoalTitleCard extends StatelessWidget {
  final GoalModel goal;
  const GoalTitleCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing20),
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
            '${goal.startDate} - ${goal.endDate}',
            style: AppTextStyles.body5,
          ),
          Text(goal.title, style: AppTextStyles.body2),
          Text(
            goal.description ?? 'No description available.',
            style: AppTextStyles.body4.copyWith(
              fontStyle: goal.description == null ? FontStyle.italic : null,
            ),
          ),
        ],
      ),
    );
  }
}
