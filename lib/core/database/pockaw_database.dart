import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pockaw/core/database/daos/category_dao.dart';
import 'package:pockaw/core/database/daos/checklist_item_dao.dart';
import 'package:pockaw/core/database/daos/goal_dao.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/checklist_item_table.dart';
import 'package:pockaw/core/database/tables/goal_table.dart';
import 'package:pockaw/core/services/data_population_service/category_population_service.dart';
import 'package:pockaw/core/utils/logger.dart';

part 'pockaw_database.g.dart';

@DriftDatabase(
  tables: [Categories, Goals, ChecklistItems],
  daos: [CategoryDao, GoalDao, ChecklistItemDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Called when the database is created for the first time.
        await m.createAll(); // Creates all tables defined in this database
        // After tables are created, populate default categories.
        // Note: 'this' refers to the AppDatabase instance.
        Log.i('Populating default categories via onCreate...');
        await CategoryPopulationService.populate(this);
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
        }
        if (from == 2 && to == 3) {
          await m.deleteTable('goals');
          await m.createTable(goals);
          await m.deleteTable('checklist_items');
          await m.createTable(checklistItems);
        }
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
