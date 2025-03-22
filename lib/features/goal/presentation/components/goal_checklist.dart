import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_item.dart';

class GoalChecklist extends StatelessWidget {
  const GoalChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => const GoalChecklistItem(),
      separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
    );
  }
}
