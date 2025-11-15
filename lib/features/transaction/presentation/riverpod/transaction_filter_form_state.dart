import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_filter_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart'
    as category_repository;
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class TransactionFilterFormState {
  final TextEditingController keywordController;
  final TextEditingController minAmountController;
  final TextEditingController maxAmountController;
  final TextEditingController notesController;
  final TextEditingController categoryController;
  final TextEditingController dateFieldController;
  final ValueNotifier<TransactionType> selectedTransactionType;
  final ValueNotifier<CategoryModel?> selectedCategory;

  TransactionFilterFormState({
    required this.keywordController,
    required this.minAmountController,
    required this.maxAmountController,
    required this.notesController,
    required this.categoryController,
    required this.dateFieldController,
    required this.selectedTransactionType,
    required this.selectedCategory,
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

  void onTypeSelected(TransactionType type) {
    selectedTransactionType.value = type;
  }

  void applyFilter(WidgetRef ref, BuildContext context) {
    // Use filterDatePickerProvider for date range
    final dateRange = ref.read(filterDatePickerProvider);
    final dateStart = dateRange[0];
    final dateEnd = dateRange[1];

    final filter = TransactionFilter(
      keyword: keywordController.text.isNotEmpty
          ? keywordController.text
          : null,
      minAmount: minAmountController.text.isNotEmpty
          ? minAmountController.text.takeNumericAsDouble()
          : null,
      maxAmount: maxAmountController.text.isNotEmpty
          ? maxAmountController.text.takeNumericAsDouble()
          : null,
      notes: notesController.text.isNotEmpty ? notesController.text : null,
      category: selectedCategory.value,
      transactionType: selectedTransactionType.value,
      dateStart: dateStart?.toMidnightStart,
      dateEnd: dateEnd?.toMidnightEnd,
    );

    ref.read(transactionFilterProvider.notifier).setFilter(filter);
    Log.d(filter.toJson(), label: 'applied filters');
    context.pop();
  }

  void reset(WidgetRef ref) {
    keywordController.clear();
    minAmountController.clear();
    maxAmountController.clear();
    notesController.clear();
    categoryController.clear();
    dateFieldController.clear();
    selectedTransactionType.value = TransactionType.expense;
    selectedCategory.value = null;
    // Reset date picker provider as well
    ref.read(filterDatePickerProvider.notifier).setRange([
      DateTime.now().subtract(const Duration(days: 5)),
      DateTime.now(),
    ]);
  }

  void dispose() {
    keywordController.dispose();
    minAmountController.dispose();
    notesController.dispose();
    categoryController.dispose();
    selectedTransactionType.dispose();
    selectedCategory.dispose();
  }
}

TransactionFilterFormState useTransactionFilterFormState({
  required WidgetRef ref,
  TransactionFilter? initialFilter,
}) {
  final activeWallet = ref.read(activeWalletProvider);
  final keywordController = useTextEditingController(
    text: initialFilter?.keyword ?? '',
  );
  final minAmountController = useTextEditingController(
    text: initialFilter?.minAmount == null
        ? ''
        : '${activeWallet.asData?.value?.currencyByIsoCode(ref).symbol} ${initialFilter?.minAmount?.toPriceFormat()}',
  );
  final maxAmountController = useTextEditingController(
    text: initialFilter?.maxAmount == null
        ? ''
        : '${activeWallet.asData?.value?.currencyByIsoCode(ref).symbol} ${initialFilter?.maxAmount?.toPriceFormat()}',
  );
  final notesController = useTextEditingController(
    text: initialFilter?.notes ?? '',
  );
  final categoryController = useTextEditingController(
    text: initialFilter?.category?.title ?? '',
  );
  final dateFieldController = useTextEditingController();

  final selectedTransactionType = useState<TransactionType>(
    initialFilter?.transactionType ?? TransactionType.expense,
  );
  final selectedCategory = useState<CategoryModel?>(initialFilter?.category);

  // Set date picker provider if filter has dates
  useState(() {
    if (initialFilter?.dateStart != null && initialFilter?.dateEnd != null) {
      ref.read(filterDatePickerProvider.notifier).setRange([
        initialFilter!.dateStart,
        initialFilter.dateEnd,
      ]);
    }
    return null;
  });

  return TransactionFilterFormState(
    keywordController: keywordController,
    minAmountController: minAmountController,
    maxAmountController: maxAmountController,
    notesController: notesController,
    categoryController: categoryController,
    dateFieldController: dateFieldController,
    selectedTransactionType: selectedTransactionType,
    selectedCategory: selectedCategory,
  );
}
