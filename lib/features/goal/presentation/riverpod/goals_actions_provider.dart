import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/database_provider.dart';

/// A simple grouping of your DB write methods
class GoalsActions {
  final Future<int> Function(GoalsCompanion) add;
  final Future<bool> Function(Goal) update;
  final Future<int> Function(int) delete;

  GoalsActions({required this.add, required this.update, required this.delete});
}

/// Expose your CRUD methods via Riverpod
final goalsActionsProvider = Provider<GoalsActions>((ref) {
  final db = ref.watch(databaseProvider);
  return GoalsActions(
    add: db.goalDao.addGoal,
    update: db.goalDao.updateGoal,
    delete: db.goalDao.deleteGoal,
  );
});
