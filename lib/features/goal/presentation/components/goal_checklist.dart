// lib/features/goal/presentation/components/goal_checklist.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_item.dart';

class GoalChecklist extends StatelessWidget {
  final List<ChecklistItemModel> items;
  const GoalChecklist({super.key, required this.items});

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
