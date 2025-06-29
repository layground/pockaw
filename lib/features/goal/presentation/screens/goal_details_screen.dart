// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';

import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';
import 'package:pockaw/features/goal/presentation/components/goal_checklist_holder.dart';
import 'package:pockaw/features/goal/presentation/components/goal_title_card.dart';
import 'package:pockaw/features/goal/presentation/riverpod/date_picker_provider.dart';
import 'package:pockaw/features/goal/presentation/riverpod/goal_details_provider.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_checklist_form_dialog.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_form_dialog.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class GoalDetailsScreen extends ConsumerWidget {
  final int goalId;
  const GoalDetailsScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeModeProvider);
    final wallet = ref.watch(activeWalletProvider);
    final goalAsync = ref.watch(goalDetailsProvider(goalId));

    return CustomScaffold(
      context: context,
      title: 'My Goals',
      showBalance: false,
      actions: [
        CustomIconButton(
          onPressed: () {
            if (goalAsync.value != null) {
              ref.read(datePickerProvider.notifier).state =
                  goalAsync.value!.goalDates;

              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (context) => GoalFormDialog(goal: goalAsync.value!),
              );
            }
          },
          icon: HugeIcons.strokeRoundedEdit02,
          context: context,
          themeMode: themeMode,
        ),
        Gap(AppSpacing.spacing8),
        if (goalAsync.value != null)
          CustomIconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) {
                  return AlertBottomSheet(
                    context: context,
                    title: 'Delete Goal',
                    content: Text(
                      'Are you sure want to delete this goal?',
                      style: AppTextStyles.body2,
                    ),
                    confirmText: 'Delete',
                    onConfirm: () {
                      final db = ref.read(databaseProvider);
                      db.goalDao.deleteGoal(goalId);
                      context.pop();
                      context.pop();
                    },
                  );
                },
              );
            },
            icon: HugeIcons.strokeRoundedDelete02,
            context: context,
            themeMode: themeMode,
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
            child: goalAsync.when(
              data: (GoalModel goal) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GoalTitleCard(goal: goal),
                    GoalChecklistHolder(goalId: goalId),
                  ],
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return Center(child: Text('Error: $error'));
              },
              loading: () {
                return Center(child: LoadingIndicator());
              },
            ),
          ),
          PrimaryButton(
            label: 'Add Checklist Item',
            state: ButtonState.outlinedActive,
            themeMode: ref.read(themeModeProvider),
            onPressed: () {
              print('➕  Opening checklist dialog for goalId=$goalId');
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (context) => GoalChecklistFormDialog(goalId: goalId),
              );
            },
          ).floatingBottomWithContent(
            content: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Goal Target', style: AppTextStyles.body2),
                  goalAsync.when(
                    data: (GoalModel goal) {
                      return Text(
                        '${wallet.value?.currencyByIsoCode(ref).symbol} ${goal.targetAmount.toPriceFormat()}',
                        style: AppTextStyles.numericLarge,
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return Container();
                    },
                    loading: () => Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
