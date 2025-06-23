import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';

class CategoryActions {
  final AppDatabase db;

  CategoryActions(this.db);

  Future<int> add(CategoriesCompanion entry) {
    return db.addCategory(entry);
  }

  Stream<List<Category>> watchAll() {
    return db.watchAllCategories();
  }

  Future<bool> update(Category category) {
    return db.updateCategory(category);
  }

  Future<int> delete(int id) {
    return db.deleteCategory(id);
  }
}

final categoryActionsProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryActions(db);
});
