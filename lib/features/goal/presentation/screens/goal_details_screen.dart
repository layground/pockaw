// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_holder.dart';
import 'package:pockaw/features/goal/presentation/components/goal_title_card.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_checklist_form_dialog.dart';

class GoalDetailsScreen extends StatelessWidget {
  final int goalId;
  const GoalDetailsScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
    print('📄  GoalDetailsScreen.build: goalId=$goalId');
    return CustomScaffold(
      context: context,
      title: 'My Goals',
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: HugeIcons.strokeRoundedEdit01,
          iconSize: IconSize.medium,
        ),
      ],
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              AppSpacing.spacing20,
              AppSpacing.spacing20,
              150,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const GoalTitleCard(),
                GoalChecklistHolder(goalId: goalId),
              ],
            ),
          ),
          PrimaryButton(
            label: 'Add Checklist Item',
            state: ButtonState.outlinedActive,
            onPressed: () {
              print('➕  Opening checklist dialog for goalId=$goalId');
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                backgroundColor: Colors.white,
                builder: (context) => GoalChecklistFormDialog(goalId: goalId),
              );
            },
          ).floatingBottomWithContent(
            content: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Goal Target', style: AppTextStyles.body2),
                  Text('Rp. 7.550.499', style: AppTextStyles.numericLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
