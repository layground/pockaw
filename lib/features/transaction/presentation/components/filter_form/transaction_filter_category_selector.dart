import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';

class TransactionFilterCategorySelector extends HookConsumerWidget {
  final TextEditingController controller;
  final ValueChanged<CategoryModel?> onCategorySelected;

  const TransactionFilterCategorySelector({
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
          Expanded(
            child: CustomSelectField(
              context: context,
              controller: controller,
              label: 'Category',
              hint: 'Select Category',
              onTap: () async {
                final category = await context.push<CategoryModel>(
                  Routes.categoryList,
                );
                Log.d(
                  category?.toJson(),
                  label: 'category selected via text field',
                );
                if (category != null) {
                  onCategorySelected(category);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
