import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_item_model.freezed.dart';
part 'checklist_item_model.g.dart';

/// Represents an item within a checklist, typically associated with a goal.
@freezed
abstract class ChecklistItemModel with _$ChecklistItemModel {
  const ChecklistItemModel._();

  const factory ChecklistItemModel({
    /// The unique identifier for the checklist item.
    /// Null if the item is new and not yet saved to the database.
    int? id,

    /// The identifier of the [GoalModel] this checklist item belongs to.
    required int goalId,

    /// The title or description of the checklist item (e.g., "Save \$50 for concert tickets").
    required String title,

    /// An optional monetary amount associated with this checklist item.
    /// This could represent a target amount to save or spend for this specific item.
    @Default(0.0) double amount,

    /// An optional web link related to the checklist item (e.g., a link to a product page).
    @Default('') String link,

    @Default(false) bool completed,
  }) = _ChecklistItemModel;

  /// Creates a `ChecklistItemModel` instance from a JSON map.
  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemModelFromJson(json);

  /// Returns a new [ChecklistItemModel] with the 'completed' status set to the given value.
  /// This is the idiomatic way to "set" a value in an immutable Freezed class.
  ChecklistItemModel setCompleted(bool isCompleted) {
    return copyWith(completed: isCompleted);
  }

  /// Returns a new [ChecklistItemModel] with the 'completed' status toggled.
  ChecklistItemModel toggleCompleted() {
    return copyWith(completed: !completed);
  }
}
