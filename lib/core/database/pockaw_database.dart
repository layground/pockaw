import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pockaw/core/database/daos/category_dao.dart';
import 'package:pockaw/core/database/daos/transaction_dao.dart';
import 'package:pockaw/core/database/daos/checklist_item_dao.dart';
import 'package:pockaw/core/database/daos/goal_dao.dart';
import 'package:pockaw/core/database/daos/wallet_dao.dart'; // Import new DAO
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
  tables: [Categories, Goals, ChecklistItems, Transactions, Wallets],
  daos: [CategoryDao, GoalDao, ChecklistItemDao, TransactionDao, WalletDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 7; // Increment schema version

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
        if (kDebugMode) {
          final m = createMigrator(); // changed to this
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
            await m.createTable(table);
            Log.i('Populating default categories via onCreate...');
            await CategoryPopulationService.populate(this);
            Log.i('Populating default wallets via onCreate...');
            await WalletPopulationService.populate(this);
          }
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
