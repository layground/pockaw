import 'package:flutter/material.dart';

import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';
import 'package:pockaw/features/goal/presentation/riverpod/date_picker_provider.dart';
import 'package:pockaw/features/goal/presentation/components/goal_date_range_picker.dart';
import 'package:pockaw/features/goal/presentation/services/goal_form_service.dart'; // for Value

class GoalFormDialog extends ConsumerStatefulWidget {
  const GoalFormDialog({super.key});

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

    return CustomBottomSheet(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.spacing16,
          children: [
            CustomTextField(
              controller: _titleController,
              label: 'Title',
              hint: 'Lunch with my friends',
              isRequired: true,
              prefixIcon: HugeIcons.strokeRoundedArrangeByLettersAZ,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
            ),
            const GoalDateRangePicker(),
            CustomTextField(
              controller: _noteController,
              label: 'Write a note',
              hint: 'Write here...',
              prefixIcon: HugeIcons.strokeRoundedNote,
              suffixIcon: HugeIcons.strokeRoundedAlignLeft,
              minLines: 1,
              maxLines: 3,
            ),
            PrimaryButton(
              label: 'Save',
              state: ButtonState.active,
              onPressed: () {
                GoalFormService().save(
                  context,
                  ref,
                  GoalModel(
                    title: _titleController.text,
                    targetAmount: 0,
                    createdAt: DateTime.now(),
                    deadlineDate: dateRange.length > 1 && dateRange[1] != null
                        ? dateRange[1]!
                        : dateRange.first!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
