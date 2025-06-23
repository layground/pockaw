import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart'
    show ButtonChip;
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_dropdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_actions_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pockaw/features/category_picker/presentation/riverpod/categories_list_provider.dart';

class CategoryPickerScreen extends HookConsumerWidget {
  final bool isPickingParent;
  final String? initialType; // New parameter to receive initial type
  const CategoryPickerScreen({
    super.key,
    this.isPickingParent = false,
    this.initialType, // Initialize new parameter
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesListProvider);
    final String currentType =
        initialType ?? 'expense'; // Use initialType directly

    print(
        '📝 CategoryPickerScreen: Displaying categories for type: ${currentType}'); // Log the type being displayed

    return CustomScaffold(
      context: context,
      title:
          'Pick ${currentType == 'expense' ? 'Expense' : 'Income'} Category', // Dynamic title
      showBalance: false,
      body: Stack(
        children: [
          ListView(
            children: [
              categoriesAsyncValue.when(
                data: (categories) {
                  final filteredCategories = categories
                      .where((category) => category.type == currentType)
                      .toList();

                  if (filteredCategories.isEmpty) {
                    print(
                        '📋 CategoryPickerScreen: No categories found for type ${currentType}');
                    return Center(
                        child: Text(
                            'No ${currentType} categories yet.')); // Updated empty state message
                  }

                  print(
                      '📋 CategoryPickerScreen: Displaying ${filteredCategories.length} categories for type ${currentType}');

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing20,
                      vertical: AppSpacing.spacing20,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return CategoryDropdown(
                        category: category,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Gap(AppSpacing.spacing12),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  print(
                      '❌ CategoryPickerScreen: Error loading categories: $error');
                  return Center(child: Text('Error: $error'));
                },
              ),
            ],
          ),
          if (!isPickingParent)
            PrimaryButton(
              label: 'Add New Category',
              state: ButtonState.outlinedActive,
              onPressed: () {
                context.push(Routes.categoryForm,
                    extra: currentType); // Pass currentType to CategoryForm
                print(
                    '📝 CategoryPickerScreen: Navigating to add new category with type: ${currentType}');
              },
            ).floatingBottom,
        ],
      ),
    );
  }
}
