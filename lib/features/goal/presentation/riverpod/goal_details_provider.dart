import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/goal_table.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';

final goalDetailsProvider = StreamProvider.autoDispose.family<GoalModel, int>((
  ref,
  id,
) {
  final db = ref.watch(databaseProvider);
  return db.goalDao.watchGoalByID(id).map((event) => event.toModel());
});
