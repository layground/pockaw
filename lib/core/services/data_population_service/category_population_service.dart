import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart';

class CategoryPopulationService {
  static Future<void> populate(AppDatabase db) async {
    Log.i('Initializing default categories...');
    final allDefaultCategories = categories.getAllCategories();
    final categoryDao = db.categoryDao;

    for (final categoryModel in allDefaultCategories) {
      final companion = CategoriesCompanion(
        id: Value(
          categoryModel.id!,
        ), // Assuming IDs are always present in defaults
        title: Value(categoryModel.title),
        icon: Value(categoryModel.icon),
        parentId: categoryModel.parentId == null
            ? const Value.absent()
            : Value(categoryModel.parentId),
        description:
            categoryModel.description == null ||
                categoryModel.description!.isEmpty
            ? const Value.absent()
            : Value(categoryModel.description!),
      );
      try {
        await categoryDao.upsertCategory(companion);
      } catch (e) {
        Log.e('Failed to upsert category ${categoryModel.title}: $e');
        // Decide if you want to stop initialization or continue
      }
    }

    Log.i(
      'Default categories initialization complete. (${allDefaultCategories.length} total categories processed)',
    );
  }
}
