import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_date_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_picker.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_image_preview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_form_state_provider.dart';
import 'package:pockaw/core/db/app_database.dart' hide Category;
import 'package:pockaw/core/db/app_database.dart' as db show Category, Account;

class TransactionForm extends HookConsumerWidget {
  final String? initialTitle;
  final double? initialAmount;
  final DateTime? initialDate;
  final String? initialDescription;
  final String? initialCategoryTitle;
  final String? initialAccount;

  TransactionForm(
      {super.key,
      this.initialTitle,
      this.initialAmount,
      this.initialDate,
      this.initialDescription,
      this.initialCategoryTitle,
      this.initialAccount});

  final border = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  final roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDatabase = ref.read(appDatabaseProvider);
    print('DEBUG: TransactionForm - initialCategory: ${initialCategoryTitle}');
    print('DEBUG: TransactionForm - initialAccount: $initialAccount');
    final titleController = useTextEditingController(text: initialTitle ?? '');
    final amountController = useTextEditingController(
        text: initialAmount != null ? initialAmount.toString() : '');
    final noteController =
        useTextEditingController(text: initialDescription ?? '');
    final formState = ref.watch(transactionFormStateProvider);
    final formNotifier = ref.read(transactionFormStateProvider.notifier);
    final selectedType = useState<String>('expense');
    final selectedCategory = useState<db.Category?>(null);
    final selectedAccount = useState<db.Account?>(null);
    final accountFieldController =
        useTextEditingController(text: initialAccount ?? '');

    // Listener for form state changes
    ref.listen<TransactionFormState>(
      transactionFormStateProvider,
      (previous, next) {
        if (next.status == TransactionFormStatus.success) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaction saved!')),
            );
            print('✔️ TransactionForm: Transaction saved successfully!');
            context.pop();
          }
        } else if (next.status == TransactionFormStatus.error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(next.errorMessage ?? 'Error'),
                  backgroundColor: Colors.red),
            );
            print('❌ TransactionForm: Failed to save transaction!');
          }
        }
      },
    );

    useEffect(() {
      if (initialAccount != null) {
        appDatabase.getAccountByName(initialAccount!).then((account) {
          if (account != null) {
            selectedAccount.value = account;
            print(
                'DEBUG: TransactionForm - selectedAccount set to: ${account.name}');
          }
        });
      }
      if (initialCategoryTitle != null) {
        appDatabase.getCategoryByTitle(initialCategoryTitle!).then((category) {
          if (category != null) {
            selectedCategory.value = category;
            print(
                'DEBUG: TransactionForm - selectedCategory set to: ${category.title}');
          }
        });
      }
      return null;
    }, [initialCategoryTitle, initialAccount]);

    print(
        'DEBUG: TransactionForm - build called. selectedCategory.value: ${selectedCategory.value?.title}');
    print(
        'DEBUG: TransactionForm - selectedAccount.value: ${selectedAccount.value?.name}');

    return CustomScaffold(
      context: context,
      title: 'Add Transaction',
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
                        active: selectedType.value == 'income',
                        onTap: () => selectedType.value = 'income',
                      ),
                      ButtonChip(
                        label: 'Expense',
                        active: selectedType.value == 'expense',
                        onTap: () => selectedType.value = 'expense',
                      ),
                      ButtonChip(
                        label: 'Transfer',
                        active: selectedType.value == 'transfer',
                        onTap: () => selectedType.value = 'transfer',
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.spacing12),
                  CustomTextField(
                    controller: titleController,
                    label: 'Title',
                    hint: 'Lunch with my friends',
                    prefixIcon: TablerIcons.letter_case,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomNumericField(
                    controller: amountController,
                    label: 'Amount',
                    hint: '\$ 34',
                    icon: TablerIcons.coin,
                    isRequired: true,
                    autofocus: true,
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomSelectField(
                    label: 'Category',
                    hint: selectedCategory.value?.title ?? 'Select Category',
                    isRequired: true,
                    onTap: () async {
                      print('📝 TransactionForm: Tapping on category field');
                      print(
                          '📝 TransactionForm: Preparing to navigate with type: \\${selectedType.value}');
                      final result = await context.push<db.Category>(
                        Routes.categoryList,
                        extra: selectedType.value,
                      );
                      if (result != null) {
                        selectedCategory.value = result;
                        print(
                            '✔️ TransactionForm: Selected category: \\${result.title}');
                      }
                    },
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomSelectField(
                    label: 'Account',
                    hint: selectedAccount.value?.name ?? 'Select Account',
                    isRequired: true,
                    onTap: () async {
                      print('📝 TransactionForm: Tapping on account field');
                      print(
                          '📝 TransactionForm: Preparing to navigate with type: \\${selectedType.value}');
                      final result = await context.push<db.Account>(
                        Routes.accountList,
                        extra: selectedType.value,
                      );
                      if (result != null) {
                        selectedAccount.value = result;
                        print(
                            '✔️ TransactionForm: Selected account: \\${result.name}');
                      }
                    },
                  ),
                  const Gap(AppSpacing.spacing16),
                  TransactionDatePicker(initialDate: initialDate),
                  const Gap(AppSpacing.spacing16),
                  CustomTextField(
                    controller: noteController,
                    label: 'Write a note',
                    hint: 'Write here...',
                    prefixIcon: TablerIcons.note,
                    suffixIcon: TablerIcons.align_left,
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
          if (formState.status == TransactionFormStatus.error)
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SnackBar(
                  content: Text(formState.errorMessage ?? 'Error'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PrimaryButton(
              label: formState.status == TransactionFormStatus.loading
                  ? 'Saving...'
                  : 'Save',
              state: ButtonState.active,
              onPressed: formState.status == TransactionFormStatus.loading
                  ? null
                  : () async {
                      final title = titleController.text.trim();
                      final amountText = amountController.text
                          .trim()
                          .replaceAll(RegExp(r'[^0-9\.]'), '');
                      final amount = double.tryParse(amountText) ?? 0;

                      if (selectedCategory.value == null) {
                        formNotifier.setError('Please select a category');
                        return;
                      }

                      if (selectedAccount.value == null) {
                        formNotifier.setError('Please select an account');
                        return;
                      }

                      // Prepare transaction data
                      final transactionData = TransactionsCompanion(
                        title: Value(title),
                        amount: Value(amount),
                        date: Value(formState.selectedDate),
                        description: Value(noteController.text.trim()),
                        categoryId: Value(selectedCategory.value!.id),
                        transactionType: Value(selectedType.value),
                        accountId: Value(selectedAccount.value!.id),
                        // Add imagePath if available
                        imagePath: Value(formState.imagePath),
                      );

                      if (formState.isEditing) {
                        formNotifier.updateTransaction(
                            formState.transactionId!,
                            transactionData.copyWith(
                                id: Value(formState.transactionId!)));
                      } else {
                        formNotifier.addTransaction(transactionData);
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
