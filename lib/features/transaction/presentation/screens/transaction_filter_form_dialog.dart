import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/features/transaction/data/model/transaction_filter_model.dart';
import 'package:pockaw/features/transaction/presentation/components/filter_form/transaction_filter_category_selector.dart';
import 'package:pockaw/features/transaction/presentation/components/filter_form/transaction_filter_type_selector.dart';
import 'package:pockaw/features/transaction/presentation/components/filter_form/transaction_filter_date_picker.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_filter_form_state.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';

class TransactionFilterFormDialog extends HookConsumerWidget {
  final TransactionFilter? initialFilter;
  const TransactionFilterFormDialog({super.key, this.initialFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useTransactionFilterFormState(
      ref: ref,
      initialFilter: initialFilter ?? ref.watch(transactionFilterProvider),
    );

    return CustomBottomSheet(
      title: 'Search & Filters',
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.spacing16,
          children: [
            TransactionFilterTypeSelector(
              selectedType: formState.selectedTransactionType.value,
              onTypeSelected: formState.onTypeSelected,
            ),
            CustomTextField(
              context: context,
              controller: formState.keywordController,
              hint: 'Dinner with ...',
              label: 'Search with keyword',
            ),
            TransactionFilterCategorySelector(
              controller:
                  formState.categoryController, // For displaying the text
              onCategorySelected: (category) {
                formState.selectedCategory.value = category;
                formState.categoryController.text = formState.getCategoryText();
              },
            ),
            TransactionFilterDatePicker(
              controller: formState.dateFieldController,
            ),
            Row(
              spacing: AppSpacing.spacing8,
              children: [
                Expanded(
                  child: CustomNumericField(
                    label: 'Min. Amount',
                    hint: '100,000',
                    appendCurrencySymbolToHint: true,
                    controller: formState.minAmountController,
                  ),
                ),
                Expanded(
                  child: CustomNumericField(
                    label: 'Max. Amount',
                    hint: '2,500,000',
                    appendCurrencySymbolToHint: true,
                    controller: formState.maxAmountController,
                  ),
                ),
              ],
            ),
            PrimaryButton(
              label: 'Apply Filters',
              onPressed: () => formState.applyFilter(ref, context),
            ),
            TextButton(
              child: Text(
                'Reset Filters',
                style: AppTextStyles.body2.copyWith(color: AppColors.red),
              ),
              onPressed: () {
                context.openBottomSheet(
                  child: AlertBottomSheet(
                    title: 'Reset Filters',
                    content: Text(
                      'Continue to reset transaction filters?',
                      style: AppTextStyles.body2,
                    ),
                    onConfirm: () {
                      formState.reset(ref);
                      ref.read(transactionFilterProvider.notifier).clear();
                      context.pop();
                      context.pop();
                    },
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
