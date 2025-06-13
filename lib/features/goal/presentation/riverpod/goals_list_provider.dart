import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/goal_table.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart'; // your existing singleton

/// Emits a new list of all Goal rows whenever the table changes
final goalsListProvider = StreamProvider.autoDispose<List<GoalModel>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.goalDao.watchAllGoals().map(
    (event) => event.map((e) => e.toModel()).toList(),
  );
});
