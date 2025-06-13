import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_item_model.freezed.dart';
part 'checklist_item_model.g.dart';

/// Represents an item within a checklist, typically associated with a goal.
@freezed
class ChecklistItemModel with _$ChecklistItemModel {
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
    double? amount,

    /// An optional web link related to the checklist item (e.g., a link to a product page).
    String? link,
  }) = _ChecklistItemModel;

  /// Creates a `ChecklistItemModel` instance from a JSON map.
  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemModelFromJson(json);
}
