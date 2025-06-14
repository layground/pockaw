import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/utils/logger.dart'; // Import your logger
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/category_table.dart'
    show CategoryTableExtensions; // Import for toModel()
import 'package:pockaw/features/category/data/model/category_model.dart';

/// Provider that watches all categories from the database and transforms them
/// into a hierarchical list of [CategoryModel]s.
final hierarchicalCategoriesProvider = StreamProvider<List<CategoryModel>>((
  ref,
) {
  final db = ref.watch(databaseProvider);

  return db.categoryDao.watchAllCategories().map((flatDriftCategories) {
    Log.d(
      'Flat Drift Categories from DB (count: ${flatDriftCategories.length})',
    );
    // for (var cat in flatDriftCategories) {
    //   Log.d('- ID: ${cat.id}, Title: ${cat.title}, ParentID: ${cat.parentId}');
    // }
    return _buildCategoryHierarchy(flatDriftCategories);
  });
});

/// Helper function to build a hierarchical list of [CategoryModel]s from a flat list
/// of Drift [Category] entities.
List<CategoryModel> _buildCategoryHierarchy(
  List<Category> flatDriftCategories,
) {
  if (flatDriftCategories.isEmpty) {
    return [];
  }

  // Convert all Drift categories to CategoryModels.
  // The `toModel()` extension initially sets `subCategories` to null.
  final List<CategoryModel> allModels = flatDriftCategories
      .map((driftCategory) => driftCategory.toModel())
      .toList();

  // Group models by their parentId for easy lookup of children.
  final Map<int?, List<CategoryModel>> childrenByParentIdMap = {};
  for (final model in allModels) {
    childrenByParentIdMap.putIfAbsent(model.parentId, () => []).add(model);
  }

  // Recursive function to build the hierarchy for children of a given parentId.
  List<CategoryModel>? buildChildrenForParent(int? parentId) {
    final List<CategoryModel>? children = childrenByParentIdMap[parentId];

    if (children == null || children.isEmpty) {
      return null; // No children, so subCategories should be null.
    }

    return children.map((child) {
        // Recursively find and assign subCategories for the current child.
        return child.copyWith(subCategories: buildChildrenForParent(child.id));
      }).toList()
      // Sort children alphabetically by title for consistent display
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  // Start building the hierarchy from top-level categories (those with parentId == null).
  final List<CategoryModel> topLevelCategories =
      buildChildrenForParent(null) ?? [];
  // Sort top-level categories alphabetically
  topLevelCategories.sort((a, b) => a.title.compareTo(b.title));
  return topLevelCategories;
}

/// Provider to temporarily hold the selected parent category when navigating
/// back from the category picker screen.
final selectedParentCategoryProvider = StateProvider<CategoryModel?>(
  (ref) => null,
);
