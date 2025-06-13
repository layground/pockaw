import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart'
    show ButtonChip;
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_providers.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_dropdown.dart';

class CategoryPickerScreen extends ConsumerWidget {
  final bool isPickingParent;
  const CategoryPickerScreen({super.key, this.isPickingParent = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      context: context,
      title: 'Pick Category',
      showBalance: false,
      body: Stack(
        children: [
          ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: ButtonChip(label: 'Expense', active: true)),
                    Gap(AppSpacing.spacing12),
                    Expanded(child: ButtonChip(label: 'Income')),
                  ],
                ),
              ),
              ref
                  .watch(hierarchicalCategoriesProvider)
                  .when(
                    data: (categories) {
                      if (categories.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.spacing20),
                            child: Text('No categories found. Add one!'),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing20,
                          vertical: AppSpacing.spacing20,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (context, index) =>
                            CategoryDropdown(category: categories[index]),
                        separatorBuilder: (context, index) =>
                            const Gap(AppSpacing.spacing12),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                        Center(child: Text('Error loading categories: $error')),
                  ),
            ],
          ),
          if (!isPickingParent)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spacing20),
                child: PrimaryButton(
                  label: 'Add New Category',
                  state: ButtonState.outlinedActive,
                  onPressed: () {
                    context.push(Routes.categoryForm);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
