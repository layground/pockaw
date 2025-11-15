import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/database_provider.dart';

class ChecklistActions {
  final Future<int> Function(ChecklistItemsCompanion) add;
  final Future<bool> Function(ChecklistItem) update;
  final Future<int> Function(int) delete;

  ChecklistActions({
    required this.add,
    required this.update,
    required this.delete,
  });
}

final checklistActionsProvider = Provider<ChecklistActions>((ref) {
  final db = ref.watch(databaseProvider);
  return ChecklistActions(
    add: db.checklistItemDao.addChecklistItem,
    update: db.checklistItemDao.updateChecklistItem,
    delete: db.checklistItemDao.deleteChecklistItem,
  );
});
