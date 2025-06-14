import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';
import 'package:pockaw/features/goal/presentation/services/goal_form_service.dart';

class GoalChecklistFormDialog extends ConsumerStatefulWidget {
  final int goalId;
  final ChecklistItemModel? checklistItemModel;
  const GoalChecklistFormDialog({
    super.key,
    required this.goalId,
    this.checklistItemModel,
  });

  @override
  ConsumerState<GoalChecklistFormDialog> createState() =>
      _GoalChecklistFormDialogState();
}

class _GoalChecklistFormDialogState
    extends ConsumerState<GoalChecklistFormDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _linkController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    isEditing = widget.checklistItemModel != null;

    if (isEditing) {
      _titleController.text = widget.checklistItemModel!.title;
      _amountController.text = '${widget.checklistItemModel!.amount}';
      _linkController.text = widget.checklistItemModel!.link ?? '';
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            CustomNumericField(
              controller: _amountController,
              label: 'Price amount',
              hint: '\$ 34',
              icon: HugeIcons.strokeRoundedCoins01,
              isRequired: true,
            ),
            CustomTextField(
              controller: _linkController,
              label: 'Link or place to buy',
              hint: 'Insert or paste link here...',
              prefixIcon: HugeIcons.strokeRoundedLink01,
              suffixIcon: HugeIcons.strokeRoundedClipboard,
            ),
            PrimaryButton(
              label: 'Save',
              state: ButtonState.active,
              onPressed: () async {
                Log.d(_titleController.text, label: 'title');
                Log.d(
                  _amountController.text.takeNumericAsDouble(),
                  label: 'amount',
                );
                Log.d(_linkController.text, label: 'link');
                // return;
                GoalFormService().saveChecklist(
                  context,
                  ref,
                  isEditing: isEditing,
                  checklistItem: ChecklistItemModel(
                    title: _titleController.text,
                    amount: double.tryParse(_amountController.text) ?? 0,
                    link: _linkController.text,
                    goalId: widget.goalId,
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
