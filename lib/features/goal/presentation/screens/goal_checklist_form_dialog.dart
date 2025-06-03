// lib/features/goal/presentation/screens/goal_checklist_form_dialog.dart

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart'
    show TablerIcons;
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/goal/presentation/riverpod/checklist_actions_provider.dart';

class GoalChecklistFormDialog extends ConsumerStatefulWidget {
  final int goalId;
  const GoalChecklistFormDialog({Key? key, required this.goalId})
      : super(key: key);

  @override
  ConsumerState<GoalChecklistFormDialog> createState() =>
      _GoalChecklistFormDialogState();
}

class _GoalChecklistFormDialogState
    extends ConsumerState<GoalChecklistFormDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Add Goal Checklist',
                  style: AppTextStyles.body1,
                ),
                const Gap(AppSpacing.spacing32),
                CustomTextField(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Lunch with my friends',
                  isRequired: true,
                  prefixIcon: TablerIcons.letter_case,
                ),
                const Gap(AppSpacing.spacing16),
                CustomNumericField(
                  controller: _amountController,
                  label: 'Price amount',
                  hint: '\$ 34',
                  icon: TablerIcons.coin,
                  isRequired: true,
                ),
                const Gap(AppSpacing.spacing16),
                CustomTextField(
                  controller: _linkController,
                  label: 'Link or place to buy',
                  hint: 'Insert or paste link here...',
                  prefixIcon: TablerIcons.link,
                  suffixIcon: TablerIcons.clipboard_check_filled,
                ),
              ],
            ),
          ),
        ),
        PrimaryButton(
          label: 'Save',
          state: ButtonState.active,
          onPressed: () async {
            final actions = ref.read(checklistActionsProvider);
            final amount = double.tryParse(_amountController.text) ?? 0;
            await actions.add(
              ChecklistItemsCompanion(
                goalId: Value(widget.goalId),
                title: Value(_titleController.text),
                amount: Value(amount),
                link: Value(_linkController.text),
              ),
            );
            Navigator.of(context).pop();
          },
        ).floatingBottom,
      ],
    );
  }
}
