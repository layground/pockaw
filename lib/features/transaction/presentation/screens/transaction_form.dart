import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import hooks_riverpod
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/transaction/application/providers/transaction_providers.dart'; // Import provider
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_date_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_preview.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';
import 'package:uuid/uuid.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart'; // Assuming this is needed for date picker state

class TransactionForm extends HookConsumerWidget {
  // Change to HookConsumerWidget
  final String? transactionID;
  TransactionForm({super.key, this.transactionID});

  final border = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  final roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add WidgetRef
    // Fetch the list of transactions
    final allTransactions = ref.watch(transactionListProvider);

    // Find the transaction to edit based on the provided ID
    // Use useMemoized to find the transaction only when the ID or list changes
    final transactionToEdit = useMemoized(() {
      if (transactionID == null) return null;
      return allTransactions.firstWhereOrNull((t) => t.id == transactionID);
    }, [transactionID, allTransactions]); // Dependencies

    // Controllers for text fields
    // Initialize controllers with transaction data if editing, otherwise empty
    final titleController = useTextEditingController(
      text: transactionToEdit?.title ?? '',
    );
    final amountController = useTextEditingController(
      text:
          transactionToEdit?.amount.toStringAsFixed(2) ??
          '', // Format amount for display
    );
    final notesController = useTextEditingController(
      text: transactionToEdit?.notes ?? '',
    );

    // State for other form fields
    // Initialize state with transaction data if editing, otherwise default values
    final selectedTransactionType = useState<TransactionType>(
      transactionToEdit?.transactionType ?? TransactionType.expense,
    );
    final selectedCategory = useState<CategoryModel?>(
      transactionToEdit?.category,
    );

    // For generating unique IDs
    const uuid = Uuid();

    return CustomScaffold(
      context: context,
      title: transactionToEdit == null
          ? 'Add Transaction'
          : 'Edit Transaction', // Dynamic title
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(AppSpacing.spacing12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonChip(
                        label: 'Income',
                        active:
                            selectedTransactionType.value ==
                            TransactionType.income,
                        onTap: () => selectedTransactionType.value =
                            TransactionType.income,
                      ),
                      ButtonChip(
                        label: 'Expense',
                        active:
                            selectedTransactionType.value ==
                            TransactionType.expense,
                        onTap: () => selectedTransactionType.value =
                            TransactionType.expense,
                      ),
                      ButtonChip(
                        label: 'Transfer',
                        active:
                            selectedTransactionType.value ==
                            TransactionType.transfer,
                        onTap: () => selectedTransactionType.value =
                            TransactionType.transfer,
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.spacing12),
                  CustomTextField(
                    controller: titleController,
                    label: 'Title',
                    hint: 'Lunch with my friends',
                    // The model uses 'title', so this field maps to transaction.title
                    prefixIcon: HugeIcons.strokeRoundedArrangeByLettersAZ,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomNumericField(
                    controller: amountController,
                    label: 'Amount',
                    hint: '\$ 34',
                    icon: HugeIcons.strokeRoundedCoins01,
                    isRequired: true,
                    autofocus: true,
                  ),
                  const Gap(AppSpacing.spacing16),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        SizedBox(
                          height: double.infinity,
                          child: SecondaryButton(
                            onPressed: () {},
                            icon: HugeIcons.strokeRoundedShoppingBag01,
                          ),
                        ),
                        const Gap(AppSpacing.spacing8),
                        Expanded(
                          child: CustomSelectField(
                            label: 'Category',
                            hint:
                                '${selectedCategory.value?.title ?? ''} • ${selectedCategory.value?.subCategories?.first.title ?? ''}',
                            isRequired: true,
                            onTap: () async {
                              // Navigate to category selection and update state
                              final category = await context
                                  .push<CategoryModel>(Routes.categoryList);
                              Log.d(category?.toJson(), label: 'category');
                              if (category != null) {
                                selectedCategory.value = category;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(AppSpacing.spacing16),
                  // TransactionDatePicker needs to read/write to datePickerProvider
                  // and potentially be initialized based on transactionToEdit.date
                  // Ensure TransactionDatePicker uses datePickerProvider correctly.
                  const TransactionDatePicker(), // Assuming TransactionDatePicker uses datePickerProvider internally
                  const Gap(AppSpacing.spacing16),
                  CustomTextField(
                    controller: notesController,
                    label: 'Write a note',
                    hint: 'Write here...',
                    prefixIcon: HugeIcons.strokeRoundedNote,
                    suffixIcon: HugeIcons.strokeRoundedAlignLeft,
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const Gap(AppSpacing.spacing16),
                  const TransactionImagePicker(),
                  const Gap(AppSpacing.spacing16),
                  const TransactionImagePreview(),
                ],
              ),
            ),
          ),
          PrimaryButton(
            label: 'Save',
            state: ButtonState.active,
            onPressed: () {
              // Basic validation (can be expanded)
              if (titleController.text.isEmpty ||
                  amountController.text.isEmpty ||
                  selectedCategory.value == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all required fields.'),
                  ),
                );
                return;
              }

              // Get the current date from the date picker provider
              final dateFromPicker = ref.read(datePickerProvider);
              final imagePicker = ref.read(imageProvider);

              if (transactionToEdit == null) {
                // Creating a new transaction
                final newTransaction = Transaction(
                  id: uuid.v4(), // Generate new ID for new transaction
                  transactionType: selectedTransactionType.value,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  date: dateFromPicker, // Use date from provider
                  title: titleController.text,
                  category: selectedCategory.value!,
                  wallet: wallets.first,
                  notes: notesController.text.isNotEmpty
                      ? notesController.text
                      : null,
                  imagePath: imagePicker.imageFile?.path,
                  isRecurring: false, // Or get from form if added
                );
                Log.d('Saving New Transaction: ${newTransaction.toJson()}');
              } else {
                // Updating an existing transaction
                final updatedTransaction = transactionToEdit.copyWith(
                  transactionType: selectedTransactionType.value,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  date: dateFromPicker, // Use date from provider
                  title: titleController.text,
                  category: selectedCategory.value!,
                  notes: notesController.text.isNotEmpty
                      ? notesController.text
                      : null,
                  imagePath: imagePicker.imageFile?.path,
                  // isRecurring: ... // Update if in form
                );
                Log.d('Updating Transaction: ${updatedTransaction.toJson()}');
              }
              context.pop(); // Go back after saving
            },
          ).floatingBottom,
        ],
      ),
    );
  }
}
