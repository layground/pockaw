import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_title.dart';

class GoalChecklistHolder extends StatelessWidget {
  const GoalChecklistHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.spacing16),
      child: Column(
        children: [
          GoalChecklistTitle(),
          Gap(AppSpacing.spacing12),
          GoalChecklist(),
        ],
      ),
    );
  }
}
