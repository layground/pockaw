import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/checklist_item_table.dart';
import 'package:pockaw/core/utils/logger.dart';

part 'checklist_item_dao.g.dart';

@DriftAccessor(tables: [ChecklistItems])
class ChecklistItemDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistItemDaoMixin {
  ChecklistItemDao(super.db);

  /// Inserts a new checklist item, returns its new ID
  Future<int> addChecklistItem(ChecklistItemsCompanion entry) async {
    Log.d('addChecklistItem → ${entry.toString()}', label: 'checklist item');
    final id = await into(checklistItems).insert(entry);
    Log.d('ChecklistItem inserted with id=$id', label: 'checklist item');
    return id;
  }

  /// Fetches all checklist items.
  Future<List<ChecklistItem>> getAllChecklistItems() {
    return select(checklistItems).get();
  }

  /// Streams all items for a specific goal
  Stream<List<ChecklistItem>> watchChecklistItemsForGoal(int goalId) {
    Log.d(
      'watchChecklistItemsForGoal(goalId=$goalId)',
      label: 'checklist item',
    );
    return (select(
      checklistItems,
    )..where((tbl) => tbl.goalId.equals(goalId))).watch();
  }

  /// Updates an existing checklist item
  Future<bool> updateChecklistItem(ChecklistItem item) async {
    Log.d('updateChecklistItem → ${item.toString()}', label: 'checklist item');
    final success = await update(checklistItems).replace(item);
    Log.d('updateChecklistItem success=$success', label: 'checklist item');
    return success;
  }

  /// Deletes a checklist item by ID
  Future<int> deleteChecklistItem(int id) async {
    Log.d('deleteChecklistItem → id=$id', label: 'checklist item');
    final count = await (delete(
      checklistItems,
    )..where((t) => t.id.equals(id))).go();
    Log.d('deleteChecklistItem deleted $count row(s)', label: 'checklist item');
    return count;
  }
}
