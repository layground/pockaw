import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/goal_table.dart';
import 'package:pockaw/core/utils/logger.dart';

part 'goal_dao.g.dart';

@DriftAccessor(tables: [Goals])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(super.db);

  // ─── CRUD for Goals ─────────────────────────────

  /// Inserts a new Goal, returns its auto-incremented ID
  Future<int> addGoal(GoalsCompanion entry) async {
    Log.d('📝  addGoal → title="${entry.title.value}"');
    final id = await into(goals).insert(entry);
    Log.d('✔️  Goal inserted with id=$id');
    return id;
  }

  /// Streams all goals; logs each emission
  Stream<List<Goal>> watchAllGoals() {
    Log.d('🔍  Subscribing to watchAllGoals()');
    return select(goals).watch().map((list) {
      Log.d('📋  watchAllGoals emitted ${list.length} rows');
      return list;
    });
  }

  /// Updates an existing goal (matching by .id)
  Future<bool> updateGoal(Goal goal) async {
    Log.d('✏️  updateGoal → id=${goal.id}, title="${goal.title}"');
    final success = await update(goals).replace(goal);
    Log.d('✔️  updateGoal success=$success');
    return success;
  }

  /// Deletes a goal by its ID
  Future<int> deleteGoal(int id) async {
    Log.d('🗑️  deleteGoal → id=$id');
    final count = await (delete(goals)..where((g) => g.id.equals(id))).go();
    Log.d('✔️  deleteGoal deleted $count row(s)');
    return count;
  }
}
