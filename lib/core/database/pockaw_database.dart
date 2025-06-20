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
import 'package:pockaw/core/database/daos/wallet_dao.dart'; // Import new DAO
import 'package:pockaw/core/database/tables/budgets_table.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/transaction_table.dart';
import 'package:pockaw/core/database/tables/checklist_item_table.dart';
import 'package:pockaw/core/database/tables/goal_table.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart'; // Import new table
import 'package:pockaw/core/services/data_population_service/category_population_service.dart';
import 'package:pockaw/core/services/data_population_service/wallet_population_service.dart'; // Import new population service
import 'package:pockaw/core/utils/logger.dart';

part 'pockaw_database.g.dart';

@DriftDatabase(
  tables: [Categories, Goals, ChecklistItems, Transactions, Wallets, Budgets],
  daos: [
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
  int get schemaVersion => 8; // Increment schema version

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // beforeOpen: (openingDetails) async {
      //   if (kDebugMode) {
      //     final m = createMigrator(); // changed to this
      //     for (final table in allTables) {
      //       await m.deleteTable(table.actualTableName);
      //       await m.createTable(table);
      //     }
      //   }
      // },
      onCreate: (Migrator m) async {
        // Called when the database is created for the first time.
        await m.createAll(); // Creates all tables defined in this database
        // After tables are created, populate default categories.
        // Note: 'this' refers to the AppDatabase instance.
        Log.i('Populating default categories via onCreate...');
        await CategoryPopulationService.populate(this);
        Log.i('Populating default wallets via onCreate...');
        await WalletPopulationService.populate(this);
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
          for (final table in allTables) {
            try {
              await m.deleteTable(table.actualTableName);
            } catch (e) {
              Log.d(
                'Could not delete table ${table.actualTableName} during debug upgrade (it might not exist or already be deleted): $e',
              );
            }
          }

          // Recreate all tables based on the current schema.
          await m.createAll();
          Log.i('All tables recreated after debug upgrade.');

          // Populate default data once after tables are set up.
          Log.i('Populating default categories after debug upgrade...');
          await CategoryPopulationService.populate(this);
          Log.i('Populating default wallets after debug upgrade...');
          await WalletPopulationService.populate(this);
        } else {
          // e.g., if (from < 2) { await m.addColumn(users, users.newColumn); }
          Log.d('Production migration from $from to $to not yet implemented.');
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
    // await migrator.createAll();
    // Log.i('All tables have been recreated during reset.');

    // Repopulate initial data (delegating to the same logic as onCreate)
    await migration.onCreate(
      migrator,
    ); // This will call m.createAll() again, then populate.
    // More direct would be to call populate services directly.
    // Let's call population services directly to avoid redundant createAll.
    // Log.i('Populating default categories during reset...');
    // await CategoryPopulationService.populate(this);
    // Log.i('Populating default wallets during reset...');
    // await WalletPopulationService.populate(this);

    Log.i('Database reset and data population complete.');
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
