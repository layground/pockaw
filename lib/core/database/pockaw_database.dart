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
  int get schemaVersion => 3; // Increment schema version

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await populateData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        Log.i('Running migration from $from to $to');
        if (kDebugMode) {
          // In debug mode, clear and recreate everything.
          // Use the provided migrator 'm'.
          Log.i(
            'Debug mode: Wiping and recreating all tables for upgrade from $from to $to.',
          );

          // Delete all existing tables first.
          // Iterating in reverse order can help with foreign key constraints, though migrator might handle it.
          await clearAllDataAndReset();
          await populateData();
          Log.i('All tables recreated after debug upgrade.');
        }
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
    );
    final migrator = createMigrator();

    // Delete all tables
    for (final table in allTables) {
      try {
        await migrator.deleteTable(table.actualTableName);
        Log.i(
          'Successfully deleted table: ${table.actualTableName} during reset.',
        );
      } catch (e) {
        Log.d(
          'Could not delete table ${table.actualTableName} during reset (it might not exist): $e',
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

    Log.i('Database reset and data population complete.');
  }

  Future<void> populateData() async {
    // More direct would be to call populate services directly.
    // Let's call population services directly to avoid redundant createAll.
    Log.i('Populating default categories during reset...');
    await CategoryPopulationService.populate(this);
    Log.i('Populating default wallets during reset...');
    await WalletPopulationService.populate(this);
  }

  Future<void> resetCategories() async {
    Log.i('Deleting and recreating category table...');
    final migrator = createMigrator();
    await migrator.deleteTable(categories.actualTableName);
    await migrator.createTable(categories);

    Log.i('Populating default categories...');
    await CategoryPopulationService.populate(this);
  }

  Future<void> resetWallets() async {
    Log.i('Deleting and recreating wallet table...');
    final migrator = createMigrator();
    await migrator.deleteTable(wallets.actualTableName);
    await migrator.createTable(wallets);

    Log.i('Populating default wallets...');
    await WalletPopulationService.populate(this);
  }
}

/// https://github.com/simolus3/drift/issues/188
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'pockaw.sqlite'));
    // if (kDebugMode) {
    //   await file.delete();
    // }
    return NativeDatabase(file);
  });
}
