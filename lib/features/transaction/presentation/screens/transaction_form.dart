import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import hooks_riverpod
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_date_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_preview.dart';
import 'package:pockaw/features/transaction/presentation/components/form/transaction_type_selector.dart';
import 'package:pockaw/features/transaction/presentation/components/form/transaction_title_field.dart';
import 'package:pockaw/features/transaction/presentation/components/form/transaction_amount_field.dart';
import 'package:pockaw/features/transaction/presentation/components/form/transaction_category_selector.dart';
import 'package:pockaw/features/transaction/presentation/components/form/transaction_notes_field.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_form_state.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';

class TransactionForm extends HookConsumerWidget {
  // Change to HookConsumerWidget
  final int? transactionId;
  const TransactionForm({super.key, this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultCurrency = ref
        .read(authStateProvider)
        .defaultCurrency; // Determine if we are in "edit" mode
    final isEditing = transactionId != null;

    // Fetch transaction details if in edit mode
    final asyncTransaction = isEditing
        ? ref.watch(transactionDetailsProvider(transactionId!))
        : null;

    // Instantiate the hook. It will get the transaction data when it's ready.
    final formState = useTransactionFormState(
      ref: ref,
      defaultCurrency: defaultCurrency,
      isEditing: isEditing,
      transaction:
          asyncTransaction?.valueOrNull, // Pass current data, hook handles null
    );

    return CustomScaffold(
      context: context,
      title: !isEditing ? 'Add Transaction' : 'Edit Transaction',
      actions: [
        if (isEditing)
          CustomIconButton(
            onPressed: () {
              formState.deleteTransaction(ref, context);
            },
            icon: HugeIcons.strokeRoundedDelete02,
          ),
      ],
      body: Stack(
        fit: StackFit.expand,
        children: [
          Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing16,
                AppSpacing.spacing20,
                100,
              ),
              child: isEditing
                  ? asyncTransaction!.when(
                      // Data is already passed to the hook above.
                      // The hook's useEffect will handle updates when transactionData changes.
                      data: (transactionData) =>
                          _buildActualForm(context, ref, formState),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Text('Error loading transaction: $err'),
                      ),
                    )
                  // For new transactions, asyncTransaction is null, formState is initialized for 'new'.
                  : _buildActualForm(context, ref, formState),
            ),
          ),
          PrimaryButton(
            label: 'Save',
            state: ButtonState.active,
            // Now formState is available in this scope
            onPressed: () => formState.saveTransaction(ref, context),
          ).floatingBottom,
        ],
      ),
    );
  }

  Widget _buildActualForm(
    BuildContext context,
    WidgetRef ref,
    TransactionFormState formState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(AppSpacing.spacing12),
        TransactionTypeSelector(
          selectedType: formState.selectedTransactionType.value,
          onTypeSelected: (type) =>
              formState.selectedTransactionType.value = type,
        ),
        const Gap(AppSpacing.spacing12),
        TransactionTitleField(controller: formState.titleController),
        const Gap(AppSpacing.spacing16),
        TransactionAmountField(
          controller: formState.amountController,
          defaultCurrency: formState.defaultCurrency,
          autofocus: !formState.isEditing,
        ),
        const Gap(AppSpacing.spacing16),
        TransactionCategorySelector(
          controller: formState.categoryController, // For displaying the text
          onCategorySelected: (category) {
            formState.selectedCategory.value = category;
            formState.categoryController.text = formState.getCategoryText();
          },
        ),
        const Gap(AppSpacing.spacing16),
        TransactionDatePicker(initialDate: formState.initialTransaction?.date),
        const Gap(AppSpacing.spacing16),
        TransactionNotesField(controller: formState.notesController),
        const Gap(AppSpacing.spacing16),
        const TransactionImagePicker(),
        const Gap(AppSpacing.spacing16),
        const TransactionImagePreview(),
      ],
    );
  }
}
