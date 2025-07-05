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
    Log.d('📝  addGoal → ${entry.toString()}');
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

  /// Fetches all goals.
  Future<List<Goal>> getAllGoals() {
    return select(goals).get();
  }

  /// Streams single goal;
  Stream<Goal> watchGoalByID(int id) {
    Log.d('🔍  Subscribing to watchGoalByID($id)');
    return (select(goals)..where((g) => g.id.equals(id))).watchSingle();
  }

  /// Fetches a single goal by its ID, or null if not found.
  Future<Goal?> getGoalById(int id) {
    Log.d('🔍  Fetching getGoalById(id=$id)');
    return (select(goals)..where((g) => g.id.equals(id))).getSingleOrNull();
  }

  /// Updates an existing goal (matching by .id)
  Future<bool> updateGoal(Goal goal) async {
    Log.d('✏️  updateGoal → ${goal.toString()}');
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

  /// Streams only pinned goals
  Stream<List<Goal>> watchPinnedGoals() {
    Log.d('🔍  Subscribing to watchPinnedGoals()');
    return (select(goals)..where((g) => g.pinned.equals(true))).watch();
  }

  /// Pin a goal by its ID
  Future<void> pinGoal(int id) async {
    Log.d('📌  pinGoal → id=$id');
    await (update(goals)..where((g) => g.id.equals(id))).write(
      const GoalsCompanion(pinned: Value(true)),
    );
  }

  /// Unpin a goal by its ID
  Future<void> unpinGoal(int id) async {
    Log.d('📌  unpinGoal → id=$id');
    await (update(goals)..where((g) => g.id.equals(id))).write(
      const GoalsCompanion(pinned: Value(false)),
    );
  }
}
