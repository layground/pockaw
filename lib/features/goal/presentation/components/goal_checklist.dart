// lib/features/goal/presentation/components/goal_checklist.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_item.dart';
import 'package:pockaw/core/db/app_database.dart'; // for ChecklistItem

class GoalChecklist extends StatelessWidget {
  final List<ChecklistItem> items;
  const GoalChecklist({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No checklist items.'));
    }
    return ListView.separated(
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => GoalChecklistItem(item: items[index]),
      separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
    );
  }
}
