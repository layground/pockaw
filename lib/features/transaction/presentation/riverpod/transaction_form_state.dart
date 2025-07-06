import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart'
    as category_repository;
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

class TransactionFormState {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final TextEditingController categoryController;
  final TextEditingController dateFieldController;
  final ValueNotifier<TransactionType> selectedTransactionType;
  final ValueNotifier<CategoryModel?> selectedCategory;
  final String defaultCurrency;
  final bool isEditing;
  final TransactionModel? initialTransaction;

  TransactionFormState({
    required this.titleController,
    required this.amountController,
    required this.notesController,
    required this.categoryController,
    required this.selectedTransactionType,
    required this.selectedCategory,
    required this.dateFieldController,
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
          icon: '',
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
      Toast.show(
        'Please fill all required fields.',
        type: ToastificationType.error,
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final imagePickerState = ref.read(imageProvider);
    final activeWallet = ref.read(activeWalletProvider).valueOrNull;

    if (activeWallet == null || activeWallet.id == null) {
      Toast.show(
        'No active wallet selected.',
        type: ToastificationType.warning,
      );
      return;
    }

    String imagePath = '';
    if (await File(imagePickerState.savedPath ?? '').exists()) {
      imagePath = imagePickerState.savedPath ?? '';
    }

    // --- FIX: Use the correct date ---
    DateTime dateToSave = DateTime.now();
    if (dateFieldController.text.isNotEmpty) {
      dateToSave = dateFieldController.text
          .toDateTimeFromDayMonthYearTime12Hour();
    }

    final transactionToSave = TransactionModel(
      id: isEditing ? initialTransaction?.id : null,
      transactionType: selectedTransactionType.value,
      amount: amountController.text.takeNumericAsDouble(),
      date: dateToSave,
      title: titleController.text,
      category: selectedCategory.value!,
      wallet: activeWallet,
      notes: notesController.text.isNotEmpty ? notesController.text : null,
      imagePath: imagePath,
      isRecurring: false,
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

        if (savedTransactionId > 0) {
          await _adjustWalletBalance(ref, null, transactionToSave);
        }
      } else {
        // This is the update case
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
        await _adjustWalletBalance(ref, initialTransaction, transactionToSave);
      }

      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      Log.e('Error saving transaction: $e');
      if (context.mounted) {
        Toast.show(
          'Failed to save transaction: $e',
          type: ToastificationType.error,
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

          await _adjustWalletBalance(
            ref,
            initialTransaction!,
            null,
          ); // Pass null for newTransaction to indicate deletion

          final db = ref.read(databaseProvider);
          final id = await db.transactionDao.deleteTransaction(
            initialTransaction!.id!,
          );

          Log.d(id, label: 'deleted transaction id');
        },
      ),
    );
  }

  // This function will handle all balance adjustments: add, update, delete
  Future<void> _adjustWalletBalance(
    WidgetRef ref,
    TransactionModel?
    oldTransaction, // The original transaction (null for new additions)
    TransactionModel?
    newTransaction, // The new transaction (null for deletions)
  ) async {
    final db = ref.read(databaseProvider);
    final activeWallet = ref.read(activeWalletProvider).valueOrNull;

    if (activeWallet == null || activeWallet.id == null) {
      Log.i(
        'No active wallet or wallet ID found to adjust balance.',
        label: 'wallet adjustment',
      );
      return;
    }

    double balanceChange = 0.0;

    // 1. Reverse the effect of the old transaction (if it exists)
    if (oldTransaction != null) {
      if (oldTransaction.transactionType == TransactionType.income) {
        balanceChange -= oldTransaction.amount;
      } else if (oldTransaction.transactionType == TransactionType.expense) {
        balanceChange += oldTransaction.amount;
      }
      // Transfers are ignored for single wallet balance adjustment
    }

    // 2. Apply the effect of the new transaction (if it exists)
    if (newTransaction != null) {
      if (newTransaction.transactionType == TransactionType.income) {
        balanceChange += newTransaction.amount;
      } else if (newTransaction.transactionType == TransactionType.expense) {
        balanceChange -= newTransaction.amount;
      }
      // Transfers are ignored
    }

    double newWalletBalance = activeWallet.balance + balanceChange;

    final updatedWallet = activeWallet.copyWith(balance: newWalletBalance);
    await db.walletDao.updateWallet(updatedWallet);
    ref.read(activeWalletProvider.notifier).setActiveWallet(updatedWallet);
    Log.d(
      'Wallet balance updated for ${activeWallet.name}. Old balance: ${activeWallet.balance}, Change: $balanceChange, New balance: $newWalletBalance',
      label: 'wallet adjustment',
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
  TransactionModel? transaction,
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
  final dateFieldController = useTextEditingController();

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
      dateFieldController: dateFieldController,
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

          Future.microtask(
            () =>
                ref.read(datePickerProvider.notifier).state = transaction.date,
          );

          dateFieldController.text = transaction.date
              .toDayMonthYearTime12Hour();

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
          Future.microtask(
            () => ref.read(datePickerProvider.notifier).state = DateTime.now(),
          );
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
