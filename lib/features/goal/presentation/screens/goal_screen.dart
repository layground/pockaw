import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/presentation/components/goal_card.dart';
import 'package:pockaw/features/goal/presentation/riverpod/goals_list_provider.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_form_dialog.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final asyncGoals = ref.watch(goalsListProvider);

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
              isScrollControlled: true,
              builder: (context) => GoalFormDialog(),
            );
          },
          icon: HugeIcons.strokeRoundedPlusSign,
          context: context,
          themeMode: themeMode,
        ),
      ],
      body: asyncGoals.when(
        data: (goals) {
          if (goals.isEmpty) {
            return Center(child: Text('No goals. Add one!'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.spacing20),
            itemCount: goals.length,
            itemBuilder: (_, i) => GoalCard(goal: goals[i]),
            separatorBuilder: (_, __) => const Gap(AppSpacing.spacing12),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
