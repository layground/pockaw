import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/core/db/database_provider.dart';

class ChecklistActions {
  final Future<int> Function(ChecklistItemsCompanion) add;
  final Future<bool> Function(ChecklistItem) update;
  final Future<int> Function(int) delete;

  ChecklistActions(
      {required this.add, required this.update, required this.delete});
}

final checklistActionsProvider = Provider<ChecklistActions>((ref) {
  final db = ref.watch(databaseProvider);
  return ChecklistActions(
    add: db.addChecklistItem,
    update: db.updateChecklistItem,
    delete: db.deleteChecklistItem,
  );
});
