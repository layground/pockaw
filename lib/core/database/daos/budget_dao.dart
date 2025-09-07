import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/budgets_table.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets, Categories, Wallets])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Future<BudgetModel> _mapBudget(Budget budgetData) async {
    final wallet = await db.walletDao.getWalletById(budgetData.walletId);
    final category = await db.categoryDao.getCategoryById(
      budgetData.categoryId,
    );

    if (wallet == null || category == null) {
      throw Exception(
        'Failed to map budget: Wallet or Category not found for budget ID ${budgetData.id}',
      );
    }

    return BudgetModel(
      id: budgetData.id,
      wallet: wallet.toModel(),
      category: category.toModel(),
      amount: budgetData.amount,
      startDate: budgetData.startDate,
      endDate: budgetData.endDate,
      isRoutine: budgetData.isRoutine,
    );
  }

  Future<List<BudgetModel>> _mapBudgets(List<Budget> budgetDataList) async {
    // Fetch all required wallets and categories in batches to be more efficient
    final walletIds = budgetDataList.map((b) => b.walletId).toSet().toList();
    final categoryIds = budgetDataList
        .map((b) => b.categoryId)
        .toSet()
        .toList();

    final walletsMap = {
      for (var w in await db.walletDao.getWalletsByIds(walletIds)) w.id: w,
    };
    final categoriesMap = {
      for (var c in await db.categoryDao.getCategoriesByIds(categoryIds))
        c.id: c,
    };

    List<BudgetModel> result = [];
    for (var budgetData in budgetDataList) {
      final wallet = walletsMap[budgetData.walletId];
      final category = categoriesMap[budgetData.categoryId];
      if (wallet == null || category == null) {
        // Log this issue or handle it more gracefully
        Log.e(
          'Warning: Could not find wallet or category for budget ${budgetData.id}',
          label: 'budget',
        );
        continue; // Skip this budget if essential data is missing
      }
      result.add(
        BudgetModel(
          id: budgetData.id,
          wallet: wallet.toModel(),
          category: category.toModel(),
          amount: budgetData.amount,
          startDate: budgetData.startDate,
          endDate: budgetData.endDate,
          isRoutine: budgetData.isRoutine,
        ),
      );
    }
    return result;
  }

  // Watch all budgets
  Stream<List<BudgetModel>> watchAllBudgets() {
    return (select(budgets)..orderBy([
          (t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc),
        ]))
        .watch()
        .asyncMap(_mapBudgets);
  }

  // Get a single budget by ID
  Future<BudgetModel?> getBudgetById(int id) async {
    final budgetData = await (select(
      budgets,
    )..where((b) => b.id.equals(id))).getSingleOrNull();
    return budgetData != null ? _mapBudget(budgetData) : null;
  }

  // Watch a single budget by ID
  Stream<BudgetModel?> watchBudgetById(int id) {
    return (select(
      budgets,
    )..where((b) => b.id.equals(id))).watchSingleOrNull().asyncMap(
      (budgetData) => budgetData != null ? _mapBudget(budgetData) : null,
    );
  }

  // Add a new budget
  Future<int> addBudget(BudgetModel budgetModel) {
    return into(budgets).insert(
      BudgetsCompanion.insert(
        walletId: budgetModel.wallet.id!,
        categoryId: budgetModel.category.id!,
        amount: budgetModel.amount,
        startDate: budgetModel.startDate,
        endDate: budgetModel.endDate,
        isRoutine: budgetModel.isRoutine,
      ),
    );
  }

  // Get all budgets (for backup)
  Future<List<Budget>> getAllBudgets() {
    return select(budgets).get();
  }

  // Update an existing budget
  Future<bool> updateBudget(BudgetModel budgetModel) {
    if (budgetModel.id == null) return Future.value(false);
    return (update(budgets)..where((b) => b.id.equals(budgetModel.id!)))
        .write(
          BudgetsCompanion(
            walletId: Value(budgetModel.wallet.id!),
            categoryId: Value(budgetModel.category.id!),
            amount: Value(budgetModel.amount),
            startDate: Value(budgetModel.startDate),
            endDate: Value(budgetModel.endDate),
            isRoutine: Value(budgetModel.isRoutine),
          ),
        )
        .then((count) => count > 0);
  }

  // Delete a budget
  Future<int> deleteBudget(int id) {
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }

  // Helper method to get spent amount for a budget
  // This requires access to TransactionDao
  Future<double> getSpentAmountForBudget(BudgetModel budget) async {
    final categories = await db.categoryDao.getSubCategories(
      budget.category.id!,
    );
    final categoryIds = [...categories.map((c) => c.id), budget.category.id!];

    if (categoryIds.isEmpty) {
      return 0;
    }

    final transactions = await db.transactionDao.getTransactionsForBudget(
      categoryIds: categoryIds,
      startDate: budget.startDate,
      endDate: budget.endDate,
      walletId: budget.wallet.id!, // Filter by budget's wallet
    );

    return transactions.fold(0.0, (sum, item) async => await sum + item.amount);
  }
}
