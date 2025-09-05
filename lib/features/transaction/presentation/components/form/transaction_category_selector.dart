import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';

class TransactionCategorySelector extends HookConsumerWidget {
  final TextEditingController controller;
  final Function(CategoryModel? parentCategory, CategoryModel? category)
  onCategorySelected;

  const TransactionCategorySelector({
    super.key,
    required this.controller,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* SizedBox(
            height: double.infinity,
            child: SecondaryButton(
              onPressed: () async {
                final category = await context.push<CategoryModel>(
                  Routes.categoryList,
                );
                Log.d(
                  category?.toJson(),
                  label: 'category selected via icon button',
                );
                if (category != null) {
                  onCategorySelected(category);
                }
              },
              icon: HugeIcons.strokeRoundedShoppingBag01,
            ),
          ),
          const Gap(AppSpacing.spacing8), */
          Expanded(
            child: CustomSelectField(
              context: context,
              controller: controller,
              label: 'Category',
              hint: 'Select Category',
              isRequired: true,
              onTap: () async {
                final category = await context.push<CategoryModel>(
                  Routes.categoryList,
                );
                Log.d(
                  category?.toJson(),
                  label: 'category selected via text field',
                );
                if (category != null) {
                  final db = ref.read(databaseProvider);
                  if (category.hasParent) {
                    db.categoryDao.getCategoryById(category.parentId!).then((
                      parentCat,
                    ) {
                      onCategorySelected.call(parentCat?.toModel(), category);
                    });
                  } else {
                    onCategorySelected.call(null, category);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
