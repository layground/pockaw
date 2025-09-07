import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';

// Define tables
@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text().nullable()();
  TextColumn get iconBackground => text().nullable()();
  TextColumn get iconType => text().nullable()();
  IntColumn get parentId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get description => text().nullable()();
}

extension CategoryExtension on Category {
  /// Creates a [Category] instance from a map, typically from JSON deserialization.
  Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      iconBackground: json['iconBackground'] as String?,
      iconType: json['iconType'] as String?,
      parentId: json['parentId'] as int?,
      description: json['description'] as String?,
    );
  }
}

extension CategoryTableExtensions on Category {
  /// Converts this Drift [Category] data class to a [CategoryModel].
  ///
  /// Note: The `subCategories` field in [CategoryModel] is not populated
  /// by this direct conversion as the Drift [Category] object doesn't
  /// inherently store its children. Fetching and assembling sub-categories
  /// is typically handled at a higher layer (e.g., a repository or service)
  /// that can query for children based on `parentId`.
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      title: title,
      icon: icon ?? '',
      iconBackground: iconBackground ?? '',
      iconTypeValue: iconType ?? '',
      parentId: parentId,
      description: description,
      // subCategories are not directly available on the Drift Category object.
      // This needs to be populated by querying children if needed.
      subCategories: null,
    );
  }
}
