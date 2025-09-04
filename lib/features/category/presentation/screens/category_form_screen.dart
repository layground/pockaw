import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_confirm_checkbox.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/core/database/tables/category_table.dart'
    show CategoryTableExtensions;
import 'package:pockaw/features/category/presentation/riverpod/category_form_service.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_providers.dart';

class CategoryFormScreen extends HookConsumerWidget {
  final int? categoryId; // Nullable ID for edit mode
  final bool isEditingParent;
  const CategoryFormScreen({
    super.key,
    this.categoryId,
    this.isEditingParent = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final parentCategoryController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final iconPath = useState('');
    final makeAsParent = useState(false);
    final isEditing = categoryId != null;

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
        iconPath.value = category.icon ?? '';
      }
      return null;
    }, [categoryFuture.connectionState, categoryFuture.data]);

    if (isEditing) {
      parentCategoryController.text = selectedParentCategory?.title ?? '';
    }

    return CustomBottomSheet(
      title: '${isEditing ? 'Edit' : 'Add'} Category',
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.spacing16,
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
            IntrinsicHeight(
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      iconPath.value =
                          await context.push(Routes.categoryIconPicker) ?? '';
                      Log.d(iconPath.value, label: 'icon path');
                    },
                    child: Container(
                      height: 66,
                      width: 66,
                      padding: const EdgeInsets.all(AppSpacing.spacing8),
                      decoration: BoxDecoration(
                        color: context.purpleBackground(context.themeMode),
                        borderRadius: BorderRadius.circular(AppRadius.radius8),
                        border: Border.all(
                          color: context.purpleBorderLighter(context.themeMode),
                        ),
                      ),
                      child: Center(
                        child: iconPath.value.isEmpty
                            ? Icon(HugeIcons.strokeRoundedPizza01, size: 30)
                            : Image.asset(iconPath.value),
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.spacing8),
                  Expanded(
                    child: CustomSelectField(
                      context: context,
                      controller: parentCategoryController,
                      label: 'Parent Category',
                      hint: isEditingParent
                          ? '-'
                          : selectedParentCategory?.title ??
                                'Select Parent Category',
                      prefixIcon: HugeIcons.strokeRoundedStructure01,
                      onTap: () async {
                        // Navigate to the picker screen and wait for a result
                        final result = await context.push(
                          Routes.categoryListPickingParent,
                        );
                        // If a category was selected and returned, update the provider
                        if (result != null && result is CategoryModel) {
                          ref
                                  .read(selectedParentCategoryProvider.notifier)
                                  .state =
                              result;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            CustomTextField(
              label: 'Description',
              hint: 'Write simple description...',
              controller: descriptionController, // Use the controller
              prefixIcon: HugeIcons.strokeRoundedNote,
              suffixIcon: HugeIcons.strokeRoundedAlignLeft,
              minLines: 1,
              maxLines: 3,
            ),

            if (selectedParentCategory?.id != null)
              CustomConfirmCheckbox(
                title: 'Make as parent',
                subtitle: 'Parent category selection will be ignored on save.',
                checked: makeAsParent.value,
                onChanged: () => makeAsParent.value = !makeAsParent.value,
              ),

            PrimaryButton(
              label: 'Save',
              state: ButtonState.active,
              onPressed: () async {
                final newCategory = CategoryModel(
                  id: categoryId,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  parentId: makeAsParent.value
                      ? null
                      : selectedParentCategory?.id,
                  icon: iconPath.value,
                );

                CategoryFormService().save(
                  context,
                  ref,
                  newCategory,
                  isEditingParent: isEditingParent,
                );
              },
            ),
            if (isEditing)
              TextButton(
                child: Text(
                  'Delete',
                  style: AppTextStyles.body2.copyWith(color: AppColors.red),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (context) => AlertBottomSheet(
                      title: 'Delete Category',
                      content: Text(
                        'Deleting this category will also remove all sub-categories as well as transactions related to it. '
                        'Continue?\n\nThis action cannot be undone.',
                        style: AppTextStyles.body2,
                        textAlign: TextAlign.center,
                      ),
                      onConfirm: () {
                        final categories = ref
                            .read(hierarchicalCategoriesProvider)
                            .value;

                        CategoryModel categoryModel = categoryFuture.data!
                            .toModel();

                        if (categories != null) {
                          categoryModel = categories.firstWhere(
                            (e) => e.id == categoryId,
                          );

                          Log.d(
                            categoryModel.subCategories
                                ?.map((e) => '${e.id} => ${e.title}')
                                .toList(),
                            label: 'sub categories',
                          );
                        }

                        CategoryFormService().delete(
                          context,
                          ref,
                          categoryModel: categoryModel,
                        );
                        context.pop();
                        context.pop();
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
