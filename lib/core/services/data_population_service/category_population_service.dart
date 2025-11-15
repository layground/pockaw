import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart';

class CategoryPopulationService {
  static Future<void> populate(AppDatabase db) async {
    Log.i('Initializing default categories...', label: 'category');
    final allDefaultCategories = categories.getAllCategories();
    final categoryDao = db.categoryDao;

    for (final categoryModel in allDefaultCategories) {
      final companion = CategoriesCompanion(
        id: Value(
          categoryModel.id!,
        ), // Assuming IDs are always present in defaults
        title: Value(categoryModel.title),
        icon: Value(categoryModel.icon),
        iconBackground: Value(categoryModel.iconBackground),
        iconType: Value(categoryModel.iconTypeValue),
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
        await categoryDao.addCategory(companion);
      } catch (e) {
        Log.e(
          'Failed to add category ${categoryModel.title}: $e',
          label: 'category',
        );
        // Decide if you want to stop initialization or continue
      }
    }

    Log.i(
      'Default categories initialization complete: ${allDefaultCategories.length}',
      label: 'category',
    );
  }
}
