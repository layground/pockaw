import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class GoalChecklistTitle extends StatelessWidget {
  const GoalChecklistTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Goal Checklist',
                  style: AppTextStyles.body3,
                ),
                Text(
                  'Hold item to show options',
                  style: AppTextStyles.body5,
                ),
              ],
            ),
          ),
          Icon(
            TablerIcons.sort_ascending_2,
          )
        ],
      ),
    );
  }
}
