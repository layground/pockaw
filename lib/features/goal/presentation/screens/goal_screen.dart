import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/presentation/components/goal_card.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_form_dialog.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      showBackButton: false,
      title: 'My Goals',
      actions: [
        CustomIconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (context) => const GoalFormDialog(),
            );
          },
          icon: HugeIcons.strokeRoundedPlusSign,
          iconSize: IconSize.medium,
        ),
      ],
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing20,
          vertical: AppSpacing.spacing20,
        ),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) => const GoalCard(),
        separatorBuilder: (context, index) => const Gap(AppSpacing.spacing12),
      ),
    );
  }
}
