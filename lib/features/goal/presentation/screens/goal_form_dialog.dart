import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';
import 'package:pockaw/features/goal/presentation/riverpod/date_picker_provider.dart';
import 'package:pockaw/features/goal/presentation/components/goal_date_range_picker.dart';
import 'package:pockaw/features/goal/presentation/services/goal_form_service.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart'; // for Value

class GoalFormDialog extends HookConsumerWidget {
  final GoalModel? goal;
  const GoalFormDialog({super.key, this.goal});

  @override
  Widget build(BuildContext context, ref) {
    final wallet = ref.read(activeWalletProvider);
    final defaultCurrency = wallet.value?.currencyByIsoCode(ref).symbol;
    final dateRange = ref.watch(datePickerProvider);
    final titleController = useTextEditingController();
    final noteController = useTextEditingController();
    final targetAmountController = useTextEditingController();

    bool isEditing = false;

    useEffect(() {
      isEditing = goal != null;
      if (isEditing) {
        titleController.text = goal!.title;
        noteController.text = goal!.description ?? '';
        targetAmountController.text =
            '$defaultCurrency ${goal!.targetAmount.toPriceFormat()}';
      }

      return null;
    }, const []);

    return CustomBottomSheet(
      title: '${isEditing ? 'Edit' : 'New'} Goal',
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.spacing16,
          children: [
            CustomTextField(
              controller: titleController,
              label: 'Title',
              hint: 'Buy something',
              isRequired: true,
              prefixIcon: HugeIcons.strokeRoundedArrangeByLettersAZ,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
            ),
            GoalDateRangePicker(initialDate: dateRange),
            CustomTextField(
              controller: noteController,
              label: 'Write a note',
              hint: 'Write here...',
              prefixIcon: HugeIcons.strokeRoundedNote,
              minLines: 1,
              maxLines: 3,
            ),
            /* CustomNumericField(
              controller: targetAmountController,
              label: 'Target amount',
              hint: '1,500',
              icon: HugeIcons.strokeRoundedCoins01,
              isRequired: true,
              appendCurrencySymbolToHint: true,
            ), */
            PrimaryButton(
              label: 'Save',
              state: ButtonState.active,
              themeMode: ref.read(themeModeProvider),
              onPressed: () {
                final selectedDate = ref.watch(datePickerProvider);
                Log.d(titleController.text, label: 'title');
                Log.d(selectedDate, label: 'selected date');
                Log.d(noteController.text, label: 'note');
                Log.d(targetAmountController.text, label: 'target');

                final newGoal = GoalModel(
                  id: goal?.id,
                  title: titleController.text,
                  description: noteController.text,
                  targetAmount: targetAmountController.text
                      .takeNumericAsDouble(),
                  createdAt: DateTime.now(),
                  startDate: dateRange.first,
                  endDate: dateRange.length > 1 && dateRange[1] != null
                      ? dateRange[1]!
                      : dateRange.first!,
                );

                Log.d(newGoal.toJson(), label: 'new goal');
                // return;

                GoalFormService().save(context, ref, goal: newGoal);
              },
            ),
          ],
        ),
      ),
    );
  }
}
