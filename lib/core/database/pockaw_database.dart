import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pockaw/core/database/daos/category_dao.dart';
import 'package:pockaw/core/database/tables/category_table.dart';

part 'pockaw_database.g.dart';

@DriftDatabase(tables: [Categories], daos: [CategoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Called when the database is created for the first time.
        await m.createAll(); // Creates all tables defined in this database
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Called when the schemaVersion increases.
        // You should fill this in with logic to migrate data.
        if (from == 1 && to == 2) {
          // This block handles the migration from schema version 1 to 2.
          // Assuming version 1 had the 'categories' table with a different
          // structure (e.g., String IDs) that is incompatible with direct alteration
          // to version 2's schema (int IDs).

          // IMPORTANT: The following operations are destructive for the 'categories' table.
          // All existing data in 'categories' from schema version 1 will be lost.
          // If data preservation is critical and complex, you would need a more
          // sophisticated migration (e.g., temporary tables, data transformation).

          await m.deleteTable(
            'categories',
          ); // Delete the old 'categories' table
          await m.createTable(
            categories,
          ); // Recreate 'categories' with the new schema (v2)
          // 'categories' here refers to the TableInfo object.
        }
        // Add more migration steps for future schema versions as needed:
        // For example, if migrating from version 2 to 3:
        // if (from == 2 && to == 3) {
        //   await m.addColumn(someOtherTable, someOtherTable.newColumn);
        // }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pockaw',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  // Close the database when the provider is disposed.
  // This is good practice to release resources.
  ref.onDispose(() => db.close());
  return db;
});
