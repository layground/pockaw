import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:drift/drift.dart' show Value;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/core/database/tables/category_table.dart'
    show CategoryTableExtensions;
import 'package:pockaw/features/category/presentation/riverpod/category_providers.dart';

class CategoryFormScreen extends HookConsumerWidget {
  final int? categoryId; // Nullable ID for edit mode
  const CategoryFormScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();

    // State for the selected parent category
    final selectedParentCategory = ref.watch(selectedParentCategoryProvider);

    // Fetch existing category data if in edit mode
    final categoryFuture = useFuture(
      useMemoized(() {
        if (categoryId != null) {
          final db = ref.read(databaseProvider);
          return db.categoryDao.getCategoryById(categoryId!);
        }
        return Future.value(null); // Not in edit mode
      }, [categoryId]),
    );

    // Initialize form fields when category data is loaded
    useEffect(() {
      if (categoryFuture.connectionState == ConnectionState.done &&
          categoryFuture.data != null) {
        final category = categoryFuture.data!;
        titleController.text = category.title;
        descriptionController.text = category.description ?? '';
        if (category.parentId != null) {
          // Fetch the parent Category object from DB then convert to CategoryModel
          ref
              .read(databaseProvider)
              .categoryDao
              .getCategoryById(category.parentId!)
              .then((parentDriftCategory) {
                if (parentDriftCategory != null) {
                  ref.read(selectedParentCategoryProvider.notifier).state =
                      parentDriftCategory.toModel();
                }
              });
        } else {
          ref.read(selectedParentCategoryProvider.notifier).state = null;
        }
      }
      return null;
    }, [categoryFuture.connectionState, categoryFuture.data]);

    return CustomScaffold(
      context: context,
      title: 'Add Category',
      showBalance: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing16,
                AppSpacing.spacing20,
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: titleController, // Use the controller
                    label: 'Title',
                    hint: 'Lunch with my friends',
                    isRequired: true,
                    prefixIcon: HugeIcons.strokeRoundedTextSmallcaps,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(AppSpacing.spacing16),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        SizedBox(
                          height: double.infinity,
                          child: SecondaryButton(
                            onPressed: () {},
                            icon: HugeIcons.strokeRoundedShoppingBag01,
                          ),
                        ),
                        const Gap(AppSpacing.spacing8),
                        Expanded(
                          child: CustomSelectField(
                            label: 'Category',
                            // Display the selected parent category's title, or a default hint
                            hint:
                                selectedParentCategory?.title ??
                                'Select Parent Category (Optional)',
                            onTap: () async {
                              // Navigate to the picker screen and wait for a result
                              final result = await context.push(
                                Routes.categoryListPickingParent,
                              );
                              // If a category was selected and returned, update the provider
                              if (result != null && result is CategoryModel) {
                                ref
                                        .read(
                                          selectedParentCategoryProvider
                                              .notifier,
                                        )
                                        .state =
                                    result;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomTextField(
                    label: 'Description',
                    hint: 'Write simple description...',
                    controller: descriptionController, // Use the controller
                    prefixIcon: HugeIcons.strokeRoundedNote,
                    suffixIcon: HugeIcons.strokeRoundedAlignLeft,
                    minLines: 1,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          PrimaryButton(
            label: 'Save',
            state: ButtonState.active,
            onPressed: () async {
              // Basic validation
              if (titleController.text.trim().isEmpty) {
                // Show an error message (e.g., using a SnackBar)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category title cannot be empty.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              final db = ref.read(databaseProvider);

              // Create a CategoriesCompanion from form data
              final categoryCompanion = CategoriesCompanion(
                id: categoryId == null
                    ? const Value.absent()
                    : Value(categoryId!),
                title: Value(titleController.text.trim()),
                iconName: Value(
                  'HugeIcons.strokeRoundedShoppingBag01',
                ), // TODO: Implement icon picker
                parentId: Value(
                  selectedParentCategory?.id,
                ), // Use selected parent ID
                description: Value(
                  descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                ),
              );

              try {
                await db.categoryDao.upsertCategory(
                  categoryCompanion,
                ); // Use upsert for create/update
                // Clear the selected parent state after saving
                ref.read(selectedParentCategoryProvider.notifier).state = null;
                context.pop(); // Go back after successful save
              } catch (e) {
                // Handle database save errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save category: $e')),
                );
              }
            },
          ).floatingBottom,
        ],
      ),
    );
  }
}
