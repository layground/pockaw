import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/category_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  // --- Read Operations ---

  /// Watches all categories in the database.
  /// Returns a stream that emits a new list of categories whenever the data changes.
  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  /// Fetches all categories from the database once.
  Future<List<Category>> getAllCategories() => select(categories).get();

  /// Watches a single category by its ID.
  Stream<Category?> watchCategoryById(int id) {
    return (select(
      categories,
    )..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();
  }

  /// Fetches a single category by its ID once.
  Future<Category?> getCategoryById(int id) {
    return (select(
      categories,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Watches all top-level categories (those without a parentId).
  Stream<List<Category>> watchTopLevelCategories() {
    return (select(categories)..where((tbl) => tbl.parentId.isNull())).watch();
  }

  /// Fetches all top-level categories once.
  Future<List<Category>> getTopLevelCategories() {
    return (select(categories)..where((tbl) => tbl.parentId.isNull())).get();
  }

  /// Watches all sub-categories for a given parentId.
  Stream<List<Category>> watchSubCategories(int parentId) {
    return (select(
      categories,
    )..where((tbl) => tbl.parentId.equals(parentId))).watch();
  }

  /// Fetches all sub-categories for a given parentId once.
  Future<List<Category>> getSubCategories(int parentId) {
    return (select(
      categories,
    )..where((tbl) => tbl.parentId.equals(parentId))).get();
  }

  // --- Create Operations ---

  /// Inserts a new category into the database.
  /// The `id` within [categoryCompanion] should typically be a pre-generated UUID.
  /// Returns the inserted [Category] object.
  Future<Category> addCategory(CategoriesCompanion categoryCompanion) {
    return into(categories).insertReturning(categoryCompanion);
  }

  // --- Update Operations ---

  /// Updates an existing category in the database.
  /// This uses `replace` which means all fields of the [category] object will be updated.
  /// Returns `true` if the update was successful, `false` otherwise.
  Future<bool> updateExistingCategory(Category category) {
    return update(categories).replace(category);
  }

  /// Upserts a category: inserts if new, updates if exists based on primary key.
  Future<int> upsertCategory(CategoriesCompanion categoryCompanion) {
    return into(categories).insertOnConflictUpdate(categoryCompanion);
  }

  // --- Delete Operations ---

  /// Deletes a category by its ID.
  /// Returns the number of rows affected (usually 1 if successful).
  Future<int> deleteCategoryById(int id) {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }
}
