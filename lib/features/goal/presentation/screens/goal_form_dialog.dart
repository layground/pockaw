// lib/features/goal/presentation/screens/goal_form_dialog.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/goal/presentation/riverpod/date_picker_provider.dart';
import 'package:pockaw/features/goal/presentation/riverpod/goals_actions_provider.dart';
import 'package:pockaw/features/goal/presentation/components/goal_date_range_picker.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:drift/drift.dart' hide Column; // for Value

class GoalFormDialog extends ConsumerStatefulWidget {
  const GoalFormDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<GoalFormDialog> createState() => _GoalFormDialogState();
}

class _GoalFormDialogState extends ConsumerState<GoalFormDialog> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(datePickerProvider);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spacing20,
            0,
            AppSpacing.spacing20,
            AppSpacing.spacing20,
          ),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Goal',
                  style: AppTextStyles.body1,
                ),
                const Gap(AppSpacing.spacing32),
                CustomTextField(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Lunch with my friends',
                  isRequired: true,
                  prefixIcon: TablerIcons.letter_case,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                const Gap(AppSpacing.spacing16),
                const GoalDateRangePicker(),
                const Gap(AppSpacing.spacing16),
                CustomTextField(
                  controller: _noteController,
                  label: 'Write a note',
                  hint: 'Write here...',
                  prefixIcon: TablerIcons.note,
                  suffixIcon: TablerIcons.align_left,
                  minLines: 1,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        PrimaryButton(
          label: 'Save',
          state: ButtonState.active,
          onPressed: () async {
            final actions = ref.read(goalsActionsProvider);
            final start = dateRange.first!;
            final end = dateRange.length > 1 && dateRange[1] != null
                ? dateRange[1]!
                : dateRange.first!;

            await actions.add(
              GoalsCompanion(
                title: Value(_titleController.text),
                note: Value(_noteController.text),
                startDate: Value(start),
                endDate: Value(end),
              ),
            );
            Navigator.of(context).pop();
          },
        ).floatingBottom,
      ],
    );
  }
}
