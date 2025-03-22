import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/goal_card/goal_card.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

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
          onPressed: () {},
          icon: TablerIcons.plus,
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
