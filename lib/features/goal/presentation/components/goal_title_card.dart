import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class GoalTitleCard extends ConsumerWidget {
  final GoalModel goal;
  const GoalTitleCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.read(themeModeProvider);
    final goalDescription = goal.description ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      decoration: BoxDecoration(
        border: Border.all(color: context.secondaryBorder(themeMode)),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${goal.startDate?.toDayShortMonthYear()} - ${goal.endDate.toDayShortMonthYear()}',
            style: AppTextStyles.body5,
          ),
          Gap(AppSpacing.spacing8),
          Text(goal.title, style: AppTextStyles.body2),
          Text(
            goalDescription.isEmpty
                ? 'No description available.'
                : goal.description!,
            style: AppTextStyles.body4.copyWith(
              fontStyle: goalDescription.isEmpty ? FontStyle.italic : null,
            ),
          ),
        ],
      ),
    );
  }
}
