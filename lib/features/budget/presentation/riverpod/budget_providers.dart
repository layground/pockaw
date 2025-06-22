import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/daos/budget_dao.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

// Provider for the BudgetDao instance
final budgetDaoProvider = Provider<BudgetDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.budgetDao;
});

// Provider to stream a list of all budgets
final budgetListProvider = StreamProvider.autoDispose<List<BudgetModel>>((ref) {
  final budgetDao = ref.watch(budgetDaoProvider);
  return budgetDao.watchAllBudgets();
});

// Provider to stream details of a single budget by its ID
final budgetDetailsProvider = StreamProvider.autoDispose
    .family<BudgetModel?, int>((ref, budgetId) {
      final budgetDao = ref.watch(budgetDaoProvider);
      return budgetDao.watchBudgetById(budgetId);
    });

// Provider to get the spent amount for a specific budget
// This is an AsyncNotifier because calculating spent amount involves an async call
class BudgetSpentAmountNotifier
    extends AutoDisposeFamilyAsyncNotifier<double, BudgetModel> {
  @override
  Future<double> build(BudgetModel budget) async {
    final budgetDao = ref.watch(budgetDaoProvider);
    return budgetDao.getSpentAmountForBudget(budget);
  }
}

final budgetSpentAmountProvider = AsyncNotifierProvider.autoDispose
    .family<BudgetSpentAmountNotifier, double, BudgetModel>(
      BudgetSpentAmountNotifier.new,
    );

// Provider to fetch transactions relevant to a specific budget
final transactionsForBudgetProvider = FutureProvider.autoDispose
    .family<List<TransactionModel>, BudgetModel>((ref, budget) async {
      Log.d(budget.toJson(), label: 'budget');
      final db = ref.watch(databaseProvider);
      final activeWallet = ref.watch(activeWalletProvider).valueOrNull;
      final categories = await db.categoryDao.getSubCategories(
        budget.category.id!,
      );
      final categoryIds = [...categories.map((c) => c.id), budget.category.id!];

      // Assuming TransactionDao is accessible via db.transactionDao
      // and it has a method to stream or get transactions based on budget criteria.
      // For simplicity, using a future provider here, convert to stream if needed.
      return db.transactionDao.getTransactionsForBudget(
        categoryIds: categoryIds,
        startDate: budget.startDate,
        endDate: budget.endDate,
        walletId: activeWallet!.id ?? 0,
      ); // Convert Future to Stream for StreamProvider
    });

// Provider that defines the list of budget periods (months) to display as tabs
final budgetPeriodListProvider = Provider.autoDispose<List<DateTime>>((ref) {
  final budgetsAsync = ref.watch(budgetListProvider);

  return budgetsAsync.maybeWhen(
    data: (budgets) {
      // Extract unique months from budget start dates
      final uniqueMonthYears = budgets
          .map((b) => DateTime(b.startDate.year, b.startDate.month, 1))
          .toSet()
          .toList();

      // Sort months in descending order (most recent first)
      uniqueMonthYears.sort((a, b) => b.compareTo(a));
      return uniqueMonthYears;
    },
    orElse: () => [],
    // For loading and error states, return an empty list initially.
    // The UI can handle displaying loading/error messages based on budgetListProvider.
  );
});

// StateProvider to keep track of the currently selected budget period (month)
final selectedBudgetPeriodProvider = StateProvider.autoDispose<DateTime>((ref) {
  // Default to the start of the current month
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

// Provider that filters the budgetListProvider based on the selectedBudgetPeriodProvider
final filteredBudgetListProvider = FutureProvider.autoDispose
    .family<List<BudgetModel>, DateTime>((ref, period) {
      // Watch the stream of all budgets
      final allBudgetsStream = ref.watch(budgetListProvider);

      // Filter the stream whenever it emits a new list
      return allBudgetsStream.map(
        data: (data) {
          // Filtering logic based on the period
          final periodStart = DateTime(period.year, period.month, 1);
          final periodEnd = DateTime(
            period.year,
            period.month + 1,
            0,
          ); // Last day of the month

          return data.value.where((budget) {
            // Check if the budget's date range overlaps with the given period (month)
            return (budget.startDate.isBefore(periodEnd) ||
                    budget.startDate.isAtSameMomentAs(periodEnd)) &&
                (budget.endDate.isAfter(periodStart) ||
                    budget.endDate.isAtSameMomentAs(periodStart));
          }).toList();
        },
        error: (error) => [],
        loading: (loading) => [],
      );
    });
