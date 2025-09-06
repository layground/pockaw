import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/features/category/data/model/icon_type.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Represents a category for organizing transactions or budgets.
@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    /// The unique identifier for the category. Null if the category is new and not yet saved.
    int? id,

    /// The display name of the category (e.g., "Groceries", "Salary").
    required String title,

    /// The identifier or name of the icon associated with this category.
    /// This could be a key to lookup an icon from a predefined set (e.g., "HugeIcons.strokeRoundedShoppingBag01").
    @Default('') String icon,

    /// Icon background in hex e.g. "#cd34ff" or "cd34ff"
    @Default('') String iconBackground,

    /// The type of icon being used (emoji, initial, or asset)
    @Default('') String iconTypeValue,

    /// The identifier of the parent category, if this is a sub-category.
    /// Null if this is a top-level category.
    int? parentId,

    /// An optional description for the category.
    @Default('') String? description,

    /// A list of sub-categories. Null or empty if this category has no sub-categories.
    List<CategoryModel>? subCategories,
  }) = _CategoryModel;

  /// Creates a `CategoryModel` instance from a JSON map.
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

extension CategoryModelUtils on CategoryModel {
  /// Checks if this category is a top-level category (i.e., it has no parent).
  bool get isParent => parentId == null;

  bool get hasParent => parentId != null;

  /// Checks if this category has any sub-categories.
  bool get hasSubCategories =>
      subCategories != null && subCategories!.isNotEmpty;

  IconType get iconType {
    switch (iconTypeValue) {
      case 'emoji':
        return IconType.emoji;
      case 'initial':
        return IconType.initial;
      case 'asset':
        return IconType.asset;
      default:
        return IconType.asset;
    }
  }

  Future<CategoryModel?> getParentCategory(WidgetRef ref) async {
    if (!hasParent) return null;
    // In a real application, you would fetch the parent category from a data source.
    // Here, we just return null as a placeholder.
    return (await ref
            .read(databaseProvider)
            .categoryDao
            .getCategoryById(parentId ?? 0))
        ?.toModel();
  }

  /// A display string that might include parent information if desired,
  /// or simply the title. For now, it just returns the title.
  // String get displayNameWithHierarchy => parentId != null ? '$parentId > $title' : title;
  // You might want to fetch the parent category's name for a more user-friendly display.
}
