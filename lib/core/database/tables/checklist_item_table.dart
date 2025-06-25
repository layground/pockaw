import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/goal_table.dart';
import 'package:pockaw/features/goal/data/model/checklist_item_model.dart';

@DataClassName('ChecklistItem')
class ChecklistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId =>
      integer().references(Goals, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real().nullable()();
  TextColumn get link => text().nullable()();
  BoolColumn get completed => boolean().nullable()();
}

extension ChecklistItemExtension on ChecklistItem {
  /// Creates a [ChecklistItem] instance from a map, typically from JSON deserialization.
  ChecklistItem fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as int,
      goalId: json['goalId'] as int,
      title: json['title'] as String,
      amount: json['amount'] as double?,
      link: json['link'] as String?,
      completed: json['completed'] as bool?,
    );
  }
}

extension ChecklistItemTableExtensions on ChecklistItem {
  /// Converts this Drift [ChecklistItem] data class to a [ChecklistItemModel].
  ChecklistItemModel toModel() {
    return ChecklistItemModel(
      id: id,
      goalId: goalId,
      title: title,
      amount: amount ?? 0.0,
      link: link ?? '',
      completed: completed ?? false,
    );
  }
}
