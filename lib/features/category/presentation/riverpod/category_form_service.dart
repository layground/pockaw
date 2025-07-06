import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_actions_provider.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_providers.dart';
import 'package:toastification/toastification.dart';

class CategoryFormService {
  Future<void> save(
    BuildContext context,
    WidgetRef ref,
    CategoryModel categoryModel, {
    bool isEditingParent = false,
  }) async {
    // Basic validation
    if (categoryModel.title.isEmpty) {
      Toast.show(
        'Title and parent category cannot be empty.',
        type: ToastificationType.error,
      );
      return;
    }

    final db = ref.read(databaseProvider);

    Log.d(categoryModel.toJson(), label: 'category model');

    // Create a CategoriesCompanion from form data
    final categoryCompanion = CategoriesCompanion(
      id: categoryModel.id == null
          ? const Value.absent()
          : Value(categoryModel.id!),
      title: Value(categoryModel.title),
      icon: Value(categoryModel.icon),
      parentId: Value(categoryModel.parentId), // Use selected parent ID
      description: Value(categoryModel.description ?? ''),
    );

    try {
      final row = await db.categoryDao.upsertCategory(
        categoryCompanion,
      ); // Use upsert for create/update

      Log.d(row, label: 'row affected');
      // Clear the selected parent state after saving
      ref.read(selectedParentCategoryProvider.notifier).state = null;
      if (!context.mounted) return;
      context.pop(); // Go back after successful save
    } catch (e) {
      // Handle database save errors
      if (!context.mounted) return;
      toastification.show(
        context: context, // optional if you use ToastificationWrapper
        title: Text('Failed to save category: $e'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  void delete(
    BuildContext context,
    WidgetRef ref, {
    required CategoryModel categoryModel,
  }) {
    final actions = ref.read(categoriesActionsProvider);
    actions.delete(categoryModel.id ?? 0);
  }
}
