// ignore_for_file: avoid_print

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

@DriftDatabase(tables: [Goals, ChecklistItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from == 1) await m.createTable(checklistItems);
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
}
