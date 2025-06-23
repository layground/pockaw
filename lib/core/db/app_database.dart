// ignore_for_file: avoid_print

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
}

class ChecklistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId =>
      integer().references(Goals, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real().nullable()();
  TextColumn get link => text().nullable()();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.restrict)();
  TextColumn get transactionType =>
      text().withLength(min: 1, max: 20)(); // income, expense or transfer
  IntColumn get accountId => integer()
      .references(Accounts, #id, onDelete: KeyAction.restrict)
      .nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type =>
      text().withLength(min: 1, max: 20)(); // 'expense' or 'income'
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();
  IntColumn get parentId => integer()
      .nullable()
      .references(Categories, #id, onDelete: KeyAction.setNull)();
}

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text().withLength(
      min: 1, max: 50)(); // e.g., 'Savings Account', 'Checking Account'
  RealColumn get initialBalance => real()();
  TextColumn get transactionType =>
      text().withLength(min: 1, max: 20)(); // 'expense' or 'income'
}

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  TextColumn get timeline =>
      text().withLength(min: 1, max: 20)(); // daily, weekly, monthly
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docs = await getApplicationDocumentsDirectory(); // /.../app_flutter
    final pkg = docs.parent; // /data/data/com.layground.pockaw
    final dbDir = Directory(p.join(pkg.path, 'databases'));
    if (!await dbDir.exists()) await dbDir.create();
    final file = File(p.join(dbDir.path, 'pockaw.sqlite'));
    print('Opening DB at: ${file.path}');
    return NativeDatabase(file, logStatements: true);
  });
}

@DriftDatabase(tables: [
  Goals,
  ChecklistItems,
  Transactions,
  Categories,
  Accounts,
  Budgets
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from == 1) await m.createTable(checklistItems);
          if (from <= 2) await m.createTable(transactions);
          if (from <= 3) await m.createTable(categories);
          if (from <= 3) {
            await m.addColumn(categories, categories.icon);
          }
          if (from <= 4) {
            await m.createTable(accounts);
          }
          if (from <= 5) {
            await m.addColumn(transactions, transactions.accountId);
          }
          if (from <= 6) {
            // Add new columns to the transactions table for existing databases
            await m.addColumn(transactions, transactions.categoryId);
            await m.addColumn(transactions, transactions.transactionType);
            await m.addColumn(transactions, transactions.imagePath);

            // Optionally, update existing rows with default values if needed
            // For categoryId, you might want a default category or handle nulls.
            // For transactionType, you might set a default like 'expense'.
            // For imagePath, set to NULL.
            await customStatement(
                "UPDATE transactions SET categoryId = 1 WHERE categoryId IS NULL;"); // Assuming category with ID 1 exists as a default
            await customStatement(
                "UPDATE transactions SET transactionType = 'expense' WHERE transactionType IS NULL OR transactionType = '';");
            await customStatement(
                "UPDATE transactions SET imagePath = NULL WHERE imagePath IS NULL;");
          }
        },
        beforeOpen: (details) async {
          // Optional: clearer version logging
          print(
              '☁️  Opened DB: v${details.versionBefore} → v${details.versionNow}');
        },
      );

  // ─── CRUD for Goals ─────────────────────────────

  /// Inserts a new Goal, returns its auto-incremented ID
  Future<int> addGoal(GoalsCompanion entry) async {
    print('📝  addGoal → title="${entry.title.value}"');
    final id = await into(goals).insert(entry);
    print('✔️  Goal inserted with id=$id');
    return id;
  }

  /// Streams all goals; logs each emission
  Stream<List<Goal>> watchAllGoals() {
    print('🔍  Subscribing to watchAllGoals()');
    return select(goals).watch().map((list) {
      print('📋  watchAllGoals emitted ${list.length} rows');
      return list;
    });
  }

  /// Updates an existing goal (matching by .id)
  Future<bool> updateGoal(Goal goal) async {
    print('✏️  updateGoal → id=${goal.id}, title="${goal.title}"');
    final success = await update(goals).replace(goal);
    print('✔️  updateGoal success=$success');
    return success;
  }

  /// Deletes a goal by its ID
  Future<int> deleteGoal(int id) async {
    print('🗑️  deleteGoal → id=$id');
    final count = await (delete(goals)..where((g) => g.id.equals(id))).go();
    print('✔️  deleteGoal deleted $count row(s)');
    return count;
  }

  /// Inserts a new checklist item, returns its new ID
  Future<int> addChecklistItem(ChecklistItemsCompanion entry) async {
    print(
        '➕  addChecklistItem → goalId=${entry.goalId.value}, title="${entry.title.value}"');
    final id = await into(checklistItems).insert(entry);
    print('✔️  ChecklistItem inserted with id=$id');
    return id;
  }

  /// Streams all items for a specific goal
  Stream<List<ChecklistItem>> watchChecklistItemsForGoal(int goalId) {
    print('🔍  watchChecklistItemsForGoal(goalId=$goalId)');
    return (select(checklistItems)..where((tbl) => tbl.goalId.equals(goalId)))
        .watch();
  }

  /// Updates an existing checklist item
  Future<bool> updateChecklistItem(ChecklistItem item) async {
    print('✏️  updateChecklistItem → id=${item.id}, title="${item.title}"');
    final success = await update(checklistItems).replace(item);
    print('✔️  updateChecklistItem success=$success');
    return success;
  }

  /// Deletes a checklist item by ID
  Future<int> deleteChecklistItem(int id) async {
    print('🗑️  deleteChecklistItem → id=$id');
    final count =
        await (delete(checklistItems)..where((t) => t.id.equals(id))).go();
    print('✔️  deleteChecklistItem deleted $count row(s)');
    return count;
  }

  // ─── CRUD for Transactions ─────────────────────────────

  /// Inserts a new Transaction, returns its auto-incremented ID
  Future<int> addTransaction(TransactionsCompanion entry) async {
    print(
        '📝  addTransaction → title="${entry.title.value}", amount=${entry.amount.value}');
    final id = await into(transactions).insert(entry);
    print('✔️  Transaction inserted with id=$id');
    return id;
  }

  /// Streams all transactions
  Stream<List<Transaction>> watchAllTransactions() {
    print('🔍  Subscribing to watchAllTransactions()');
    return select(transactions).watch().map((list) {
      print('📋  watchAllTransactions emitted ${list.length} rows');
      return list;
    });
  }

  /// Updates an existing transaction
  Future<bool> updateTransaction(Transaction transaction) async {
    print(
        '✏️  updateTransaction → id=${transaction.id}, title="${transaction.title}"');
    final success = await update(transactions).replace(transaction);
    print('✔️  updateTransaction success=$success');
    return success;
  }

  /// Deletes a transaction by its ID
  Future<int> deleteTransaction(int id) async {
    print('🗑️  deleteTransaction → id=$id');
    final count =
        await (delete(transactions)..where((t) => t.id.equals(id))).go();
    print('✔️  deleteTransaction deleted $count row(s)');
    return count;
  }

  Future<Category?> getCategoryByTitle(String title) async {
    return (select(categories)..where((c) => c.title.equals(title)))
        .getSingleOrNull();
  }

  // ─── CRUD for Categories ─────────────────────────────

  /// Inserts a new Category, returns its auto-incremented ID
  Future<int> addCategory(CategoriesCompanion entry) async {
    print(
        '📝  addCategory → title="${entry.title.value}", type=${entry.type.value}');
    final id = await into(categories).insert(entry);
    print('✔️  Category inserted with id=$id');
    return id;
  }

  /// Streams all categories; logs each emission
  Stream<List<Category>> watchAllCategories() {
    print('🔍  Subscribing to watchAllCategories()');
    return select(categories).watch().map((list) {
      print('📋  watchAllCategories emitted ${list.length} rows');
      return list;
    });
  }

  /// Streams all categories by type
  Stream<List<Category>> watchCategoriesByType(String type) {
    print('🔍  Subscribing to watchCategoriesByType($type)');
    return (select(categories)..where((c) => c.type.equals(type)))
        .watch()
        .map((list) {
      print('📋  watchCategoriesByType emitted ${list.length} rows');
      return list;
    });
  }

  /// Updates an existing category (matching by .id)
  Future<bool> updateCategory(Category category) async {
    print('✏️  updateCategory → id=${category.id}, title="${category.title}"');
    final success = await update(categories).replace(category);
    print('✔️  updateCategory success=$success');
    return success;
  }

  /// Deletes a category by its ID
  Future<int> deleteCategory(int id) async {
    print('🗑️  deleteCategory → id=$id');
    final count =
        await (delete(categories)..where((c) => c.id.equals(id))).go();
    print('✔️  deleteCategory deleted $count row(s)');
    return count;
  }

  // ─── CRUD for Accounts ─────────────────────────────

  /// Inserts a new Account, returns its auto-incremented ID
  Future<int> addAccount(AccountsCompanion entry) async {
    print(
        '📝  addAccount → name="${entry.name.value}", type=${entry.type.value}');
    final id = await into(accounts).insert(entry);
    print('✔️  Account inserted with id=$id');
    return id;
  }

  /// Streams all accounts; logs each emission
  Stream<List<Account>> watchAllAccounts() {
    print('🔍  Subscribing to watchAllAccounts()');
    return select(accounts).watch().map((list) {
      print('📋  watchAllAccounts emitted ${list.length} rows');
      return list;
    });
  }

  /// Streams all accounts by transaction type
  Stream<List<Account>> watchAccountsByTransactionType(String transactionType) {
    print(
        '🔍  Subscribing to watchAccountsByTransactionType($transactionType)');
    return (select(accounts)
          ..where((a) => a.transactionType.equals(transactionType)))
        .watch()
        .map((list) {
      print('📋  watchAccountsByTransactionType emitted ${list.length} rows');
      return list;
    });
  }

  /// Updates an existing account (matching by .id)
  Future<bool> updateAccount(Account account) async {
    print('✏️  updateAccount → id=${account.id}, name="${account.name}"');
    final success = await update(accounts).replace(account);
    print('✔️  updateAccount success=$success');
    return success;
  }

  /// Deletes an account by its ID
  Future<int> deleteAccount(int id) async {
    print('🗑️  deleteAccount → id=$id');
    final count = await (delete(accounts)..where((a) => a.id.equals(id))).go();
    print('✔️  deleteAccount deleted $count row(s)');
    return count;
  }

  Future<Account?> getAccountByName(String name) async {
    return (select(accounts)..where((a) => a.name.equals(name)))
        .getSingleOrNull();
  }

  // ─── CRUD for Budgets ─────────────────────────────

  /// Inserts a new Budget, returns its auto-incremented ID
  Future<int> addBudget(BudgetsCompanion entry) async {
    print(
        '📝  addBudget → name="${entry.name.value}", amount=${entry.amount.value}, timeline=${entry.timeline.value}');
    final id = await into(budgets).insert(entry);
    print('✔️  Budget inserted with id=$id');
    return id;
  }

  /// Streams all budgets
  Stream<List<Budget>> watchAllBudgets() {
    print('🔍  Subscribing to watchAllBudgets()');
    return select(budgets).watch().map((list) {
      print('📋  watchAllBudgets emitted ${list.length} rows');
      return list;
    });
  }

  /// Updates an existing budget
  Future<bool> updateBudget(Budget budget) async {
    print('✏️  updateBudget → id=${budget.id}, name="${budget.name}"');
    final success = await update(budgets).replace(budget);
    print('✔️  updateBudget success=$success');
    return success;
  }

  /// Deletes a budget by its ID
  Future<int> deleteBudget(int id) async {
    print('🗑️  deleteBudget → id=$id');
    final count = await (delete(budgets)..where((b) => b.id.equals(id))).go();
    print('✔️  deleteBudget deleted $count row(s)');
    return count;
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
