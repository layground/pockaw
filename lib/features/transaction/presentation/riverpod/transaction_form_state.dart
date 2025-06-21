// File: f:\applications\flutter\pockaw\lib\features\transaction\presentation\hooks\use_transaction_form_state.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart'
    as category_repository; // Import the categories list
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

class TransactionFormState {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final TextEditingController categoryController;
  final ValueNotifier<TransactionType> selectedTransactionType;
  final ValueNotifier<CategoryModel?> selectedCategory;
  final String defaultCurrency;
  final bool isEditing;
  final TransactionModel?
  initialTransaction; // The resolved transaction data for editing

  TransactionFormState({
    required this.titleController,
    required this.amountController,
    required this.notesController,
    required this.categoryController,
    required this.selectedTransactionType,
    required this.selectedCategory,
    required this.defaultCurrency,
    required this.isEditing,
    this.initialTransaction,
  });

  String getCategoryText() {
    final cat = selectedCategory.value;
    if (cat == null) return '';

    if (cat.parentId != null) {
      // It's a subcategory, find its parent to display "Parent • Sub"
      final parent = category_repository.categories.firstWhere(
        (parentCat) => parentCat.id == cat.parentId,
        // Provide a fallback, though ideally parentId should always match a parent.
        orElse: () => CategoryModel(
          id: -1,
          title: 'Unknown Parent',
          iconName: '',
          subCategories: [],
        ),
      );
      return '${parent.title} • ${cat.title}';
    } else {
      // It's a parent category
      return cat.title;
    }
  }

  Future<void> saveTransaction(WidgetRef ref, BuildContext context) async {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedCategory.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final dateFromPicker = ref.read(datePickerProvider);
    final imagePickerState = ref.read(imageProvider);
    final activeWallet = ref.read(activeWalletProvider).valueOrNull;

    if (activeWallet == null || activeWallet.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active wallet selected.')),
      );
      return;
    }

    String imagePath = '';
    if (await File(imagePickerState.savedPath ?? '').exists()) {
      imagePath = imagePickerState.savedPath ?? '';
    }

    final transactionToSave = TransactionModel(
      id: isEditing ? initialTransaction?.id : null,
      transactionType: selectedTransactionType.value,
      amount: amountController.text.takeNumericAsDouble(),
      date: dateFromPicker,
      title: titleController.text,
      category: selectedCategory.value!,
      wallet: activeWallet, // Use the currently active wallet
      notes: notesController.text.isNotEmpty ? notesController.text : null,
      // Use savedPath as it reflects the persistently saved image or null if cleared/not set
      imagePath: imagePath,
      isRecurring:
          false, // Placeholder: Get from form if a recurring field is added
    );

    Log.d(
      transactionToSave.toJson(),
      label: isEditing ? 'Updating transaction' : 'Saving new transaction',
    );

    try {
      int? savedTransactionId;
      if (!isEditing) {
        savedTransactionId = await db.transactionDao.addTransaction(
          transactionToSave,
        );
      } else {
        // For updates, the ID is already in transactionToSave.id
        if (transactionToSave.id == null) {
          Log.e('Error: Attempting to update transaction without an ID.');
          toastification.show(
            description: Text('Error updating transaction: Missing ID.'),
          );
          return;
        }
        await db.transactionDao.updateTransaction(transactionToSave);
        savedTransactionId = transactionToSave.id;
      }

      // Update wallet balance
      if (savedTransactionId != null) {
        await updateWallet(ref, transactionToSave);
      }

      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      Log.e('Error saving transaction: $e');
      if (context.mounted) {
        toastification.show(
          description: Text('Failed to save transaction: $e'),
        );
      }
    }
  }

  Future<void> updateWallet(
    WidgetRef ref,
    TransactionModel initialTransaction, {
    bool isDeleting = false,
  }) async {
    final db = ref.read(databaseProvider);
    final activeWallet = ref.read(activeWalletProvider).valueOrNull;

    if (activeWallet != null) {
      double newBalance = activeWallet.balance;
      if (initialTransaction.transactionType == TransactionType.income) {
        if (isDeleting) {
          newBalance -= initialTransaction.amount;
        } else {
          newBalance += initialTransaction.amount;
        }
      } else if (initialTransaction.transactionType ==
          TransactionType.expense) {
        if (isDeleting) {
          newBalance += initialTransaction.amount;
        } else {
          newBalance -= initialTransaction.amount;
        }
      }
      // For TransactionType.transfer, balance is typically handled by moving amounts
      // between two wallets, which is a more complex operation not covered here.
      // This example only adjusts the balance of the single active wallet.

      if (initialTransaction.transactionType != TransactionType.transfer) {
        final updatedWallet = activeWallet.copyWith(balance: newBalance);
        await db.walletDao.updateWallet(updatedWallet);
        // Refresh the active wallet provider to reflect the new balance
        // This will notify all listeners of activeWalletProvider
        ref.read(activeWalletProvider.notifier).setActiveWallet(updatedWallet);
        Log.d(
          'Wallet balance updated for ${activeWallet.name}. New balance: $newBalance',
        );
      }
    }
  }

  Future<void> deleteTransaction(WidgetRef ref, BuildContext context) async {
    // Skip if not editing just in case
    if (!isEditing) return;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => AlertBottomSheet(
        context: context,
        title: 'Delete Transaction',
        content: Text(
          'Continue to delete this transaction?',
          style: AppTextStyles.body2,
        ),
        onConfirm: () async {
          if (context.mounted) {
            context.pop(); // close dialog
            context.pop(); // close form
          }

          await updateWallet(ref, initialTransaction!, isDeleting: true);

          final db = ref.read(databaseProvider);
          final id = await db.transactionDao.deleteTransaction(
            initialTransaction!.id!,
          );

          Log.d(id, label: 'deleted transaction id');
        },
      ),
    );
  }

  void dispose() {
    titleController.dispose();
    amountController.dispose();
    notesController.dispose();
    categoryController.dispose();
    selectedTransactionType.dispose();
    selectedCategory.dispose();
  }
}

TransactionFormState useTransactionFormState({
  required WidgetRef ref,
  required String defaultCurrency,
  required bool isEditing,
  TransactionModel?
  transaction, // Pass the resolved transaction data for editing
}) {
  final titleController = useTextEditingController(
    text: isEditing ? transaction?.title : '',
  );
  final amountController = useTextEditingController(
    text: isEditing && transaction != null
        ? '$defaultCurrency ${transaction.amount.toPriceFormat()}'
        : '',
  );
  final notesController = useTextEditingController(
    text: isEditing ? transaction?.notes ?? '' : '',
  );
  final categoryController = useTextEditingController();

  final selectedTransactionType = useState<TransactionType>(
    isEditing && transaction != null
        ? transaction.transactionType
        : TransactionType.expense,
  );
  final selectedCategory = useState<CategoryModel?>(
    isEditing ? transaction?.category : null,
  );

  final formState = useMemoized(
    () => TransactionFormState(
      titleController: titleController,
      amountController: amountController,
      notesController: notesController,
      categoryController: categoryController,
      selectedTransactionType: selectedTransactionType,
      selectedCategory: selectedCategory,
      defaultCurrency: defaultCurrency,
      isEditing: isEditing,
      initialTransaction: transaction,
    ),
    [defaultCurrency, isEditing, transaction],
  );

  useEffect(
    () {
      void initializeForm() {
        if (isEditing && transaction != null) {
          // Controllers are initialized with text in their declaration if transaction is available.
          // If transaction was initially null (e.g., during loading) and then becomes available,
          // we need to update them here.
          if (titleController.text != transaction.title) {
            titleController.text = transaction.title;
          }
          if (amountController.text !=
              '$defaultCurrency ${transaction.amount.toPriceFormat()}') {
            amountController.text =
                '$defaultCurrency ${transaction.amount.toPriceFormat()}';
          }
          if (notesController.text != (transaction.notes ?? '')) {
            notesController.text = transaction.notes ?? '';
          }
          if (selectedTransactionType.value != transaction.transactionType) {
            selectedTransactionType.value = transaction.transactionType;
          }
          if (selectedCategory.value != transaction.category) {
            selectedCategory.value = transaction.category;
          }
          // categoryController.text is handled by another useEffect based on selectedCategory

          final imagePath = transaction.imagePath;
          if (imagePath != null && imagePath.isNotEmpty) {
            Future.microtask(
              () => ref.read(imageProvider.notifier).loadImagePath(imagePath),
            );
          } else {
            Future.microtask(
              () => ref.read(imageProvider.notifier).clearImage(),
            );
          }
        } else if (!isEditing) {
          // Only reset for new, not if transaction is just null during edit loading
          titleController.clear();
          amountController.clear();
          notesController.clear();
          selectedTransactionType.value = TransactionType.expense;
          selectedCategory.value = null;
          // Clear image for new transaction form
          Future.microtask(() => ref.read(imageProvider.notifier).clearImage());
        }
        // categoryController text is updated by the separate effect below
      }

      initializeForm();
      // No need to return formState.dispose here if we want the hook's lifecycle
      // to be tied to the widget using it. The controllers are disposed by useTextEditingController.
      // ValueNotifiers from useState are also handled.
      // If formState.dispose did more, we'd return it.
      return null;
    },
    [
      isEditing,
      transaction,
      defaultCurrency,
      ref,
      titleController,
      amountController,
      notesController,
      selectedTransactionType,
      selectedCategory,
    ],
  );

  useEffect(
    () {
      categoryController.text = formState.getCategoryText();
      return null;
    },
    [selectedCategory.value, formState],
  ); // formState is stable due to useMemoized

  // The main dispose for controllers created by useTextEditingController
  // and ValueNotifiers from useState is handled automatically by flutter_hooks.
  // The custom `formState.dispose()` might be redundant if it only disposes these.
  // If it has other specific cleanup, it should be called.
  // For now, assuming standard hook cleanup is sufficient.

  return formState;
}
