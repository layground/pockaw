import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pockaw/core/database/daos/budget_dao.dart';
import 'package:pockaw/core/database/daos/category_dao.dart';
import 'package:pockaw/core/database/daos/transaction_dao.dart';
import 'package:pockaw/core/database/daos/checklist_item_dao.dart';
import 'package:pockaw/core/database/daos/goal_dao.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/database/daos/wallet_dao.dart'; // Import new DAO
import 'package:pockaw/core/database/tables/budgets_table.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/transaction_table.dart';
import 'package:pockaw/core/database/tables/checklist_item_table.dart';
import 'package:pockaw/core/database/tables/goal_table.dart';
import 'package:pockaw/core/database/tables/users.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart'; // Import new table
import 'package:pockaw/core/services/data_population_service/category_population_service.dart';
import 'package:pockaw/core/services/data_population_service/wallet_population_service.dart'; // Import new population service
import 'package:pockaw/core/utils/logger.dart';

part 'pockaw_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Categories,
    Goals,
    ChecklistItems,
    Transactions,
    Wallets,
    Budgets,
  ],
  daos: [
    UserDao,
    CategoryDao,
    GoalDao,
    ChecklistItemDao,
    TransactionDao,
    WalletDao,
    BudgetDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 9; // Increment schema version for the new fields

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        Log.i(
          'Creating new database and populating tables...',
          label: 'database',
        );
        await m.createAll();
        await populateData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        Log.i('Running migration from $from to $to', label: 'database');

        if (from < 8) {
          resetCategories();
          return;
        }

        // Add user_id on wallets table in version 9
        if (from < 9) {
          Log.i('Adding user_id column to wallets table...', label: 'database');
          await m.addColumn(wallets, wallets.userId);
          return;
        }

        /* if (kDebugMode) {
          // In debug mode, clear and recreate everything for other migrations
          Log.i(
            'Debug mode: Wiping and recreating all tables for upgrade from $from to $to.',
            label: 'database',
          );
          await clearAllDataAndReset();
          await populateData();
          Log.i('All tables recreated after debug upgrade.', label: 'database');

          return; // exit
        } */
      },
    );
  }

  /* static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pockaw',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  } */

  /// Clears all data from all tables, recreates them, and populates initial data.
  /// This is useful for a full reset of the application's data.
  Future<void> clearAllDataAndReset() async {
    Log.i(
      'Starting database reset: clearing all data and re-initializing tables.',
      label: 'database',
    );
    final migrator = createMigrator();

    // Delete all tables
    for (final table in allTables) {
      try {
        await migrator.deleteTable(table.actualTableName);
        Log.i(
          'Successfully deleted table: ${table.actualTableName} during reset.',
          label: 'database',
        );
      } catch (e) {
        Log.d(
          'Could not delete table ${table.actualTableName} during reset (it might not exist): $e',
          label: 'database',
        );
      }
    }

    // Recreate all tables
    await migrator.createAll();
    // Log.i('All tables have been recreated during reset.');

    // Repopulate initial data (delegating to the same logic as onCreate)
    // await migration.onCreate(
    //   migrator,
    // ); // This will call m.createAll() again, then populate.

    Log.i('Database reset and data population complete.', label: 'database');
  }

  Future<void> populateData() async {
    // More direct would be to call populate services directly.
    // Let's call population services directly to avoid redundant createAll.
    Log.i('Populating default categories during reset...', label: 'database');
    await CategoryPopulationService.populate(this);
    Log.i('Populating default wallets during reset...', label: 'database');
    await WalletPopulationService.populate(this);
  }

  // --- Data Management Methods ---

  Future<void> _deleteAllChecklistItems() => delete(checklistItems).go();
  Future<void> _deleteAllBudgets() => delete(budgets).go();
  Future<void> _deleteAllTransactions() => delete(transactions).go();
  Future<void> _deleteAllGoals() => delete(goals).go();
  Future<void> _deleteAllUsers() => delete(users).go();
  Future<void> _deleteAllWallets() => delete(wallets).go();
  Future<void> _deleteAllCategories() => delete(categories).go();

  /// Clears all data from all tables in the correct order to respect foreign key constraints.
  Future<void> clearAllTables() async {
    Log.i('Clearing all database tables...', label: 'database');
    await transaction(() async {
      // Delete in reverse dependency order
      await _deleteAllChecklistItems();
      await _deleteAllBudgets();
      await _deleteAllTransactions();
      await _deleteAllGoals();
      await _deleteAllUsers(); // Users table has no incoming FKs from other tables
      await _deleteAllWallets();
      await _deleteAllCategories();
    });
    Log.i('All database tables cleared.', label: 'database');
  }

  /// Inserts data into tables in the correct order to respect foreign key constraints.
  /// This method is designed to be used during a restore operation.
  Future<void> insertAllData(
    List<Map<String, dynamic>> usersData,
    List<Map<String, dynamic>> categoriesData,
    List<Map<String, dynamic>> walletsData,
    List<Map<String, dynamic>> budgetsData,
    List<Map<String, dynamic>> goalsData,
    List<Map<String, dynamic>> checklistItemsData,
    List<Map<String, dynamic>> transactionsData,
  ) async {
    Log.i('Inserting all data into database...', label: 'database');
    await transaction(() async {
      // Insert in dependency order
      await batch(
        (b) =>
            b.insertAll(users, usersData.map((e) => User.fromJson(e)).toList()),
      );
      await batch(
        (b) => b.insertAll(
          categories,
          categoriesData.map((e) => Category.fromJson(e)).toList(),
        ),
      );
      await batch(
        (b) => b.insertAll(
          wallets,
          walletsData.map((e) => Wallet.fromJson(e)).toList(),
        ),
      );
      await batch(
        (b) =>
            b.insertAll(goals, goalsData.map((e) => Goal.fromJson(e)).toList()),
      );
      await batch(
        (b) => b.insertAll(
          budgets,
          budgetsData.map((e) => Budget.fromJson(e)).toList(),
        ),
      );
      await batch(
        (b) => b.insertAll(
          transactions,
          transactionsData.map((e) => Transaction.fromJson(e)).toList(),
        ),
      );
      await batch(
        (b) => b.insertAll(
          checklistItems,
          checklistItemsData.map((e) => ChecklistItem.fromJson(e)).toList(),
        ),
      );
    });
    Log.i('All data inserted successfully.', label: 'database');
  }

  Future<void> resetCategories() async {
    Log.i('Deleting and recreating category table...', label: 'database');
    final migrator = createMigrator();
    await migrator.drop(categories);
    await migrator.createTable(categories);

    await populateCategories();
  }

  /// Populate categories
  Future<void> populateCategories() async {
    Log.i('Populating default categories...', label: 'database');
    await CategoryPopulationService.populate(this);
  }

  Future<void> resetWallets() async {
    Log.i('Deleting and recreating wallet table...', label: 'database');
    final migrator = createMigrator();
    await migrator.drop(wallets);
    await migrator.createTable(wallets);

    Log.i('Populating default wallets...', label: 'database');
    await WalletPopulationService.populate(this);
  }
}

/// https://github.com/simolus3/drift/issues/188
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder =
        await getApplicationSupportDirectory(); // Use support directory for database
    final file = File(join(dbFolder.path, 'pockaw.sqlite'));
    if (kDebugMode) {
      // await file.delete(); // Uncomment for fresh DB on every run in debug
    }
    return NativeDatabase(file);
  });
}
