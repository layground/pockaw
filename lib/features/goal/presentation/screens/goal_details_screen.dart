import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_holder.dart';
import 'package:pockaw/features/goal/presentation/components/goal_title_card.dart';

class GoalDetailsScreen extends StatelessWidget {
  const GoalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      showBackButton: false,
      title: 'My Goals',
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: TablerIcons.edit,
          iconSize: IconSize.medium,
        ),
      ],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.spacing20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GoalTitleCard(),
            GoalChecklistHolder(),
          ],
        ),
      ),
    );
  }
}
