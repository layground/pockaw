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
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/core/database/tables/category_table.dart'
    show CategoryTableExtensions;
import 'package:pockaw/features/category/data/model/icon_type.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_form_service.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_providers.dart';
import 'package:pockaw/features/category/presentation/screens/category_icon_emoji_picker.dart';
import 'package:pockaw/features/category/presentation/screens/category_icon_initial_picker.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_icon.dart';

part 'category_icon_dialog.dart';
part '../components/form/category_title_field.dart';
part '../components/form/category_picker_field.dart';
part '../components/form/category_description_field.dart';
part '../components/form/category_save_button.dart';
part '../components/form/category_delete_button.dart';

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
    final icon = useState('');
    final iconBackground = useState('');
    final iconType = useState(IconType.asset);
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
        icon.value = category.icon ?? '';
        iconType.value = category.toModel().iconType;
        iconBackground.value = category.iconBackground ?? '';
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
            CategoryTitleField(titleController: titleController),
            CategoryPickerField(
              icon: icon,
              iconBackground: iconBackground,
              iconType: iconType,
              parentCategoryController: parentCategoryController,
              isEditingParent: isEditingParent,
              selectedParentCategory: selectedParentCategory,
            ),
            CategoryDescriptionField(
              descriptionController: descriptionController,
            ),

            if (selectedParentCategory?.id != null)
              CustomConfirmCheckbox(
                title: 'Make as parent',
                subtitle: 'Parent category selection will be ignored on save.',
                checked: makeAsParent.value,
                onChanged: () => makeAsParent.value = !makeAsParent.value,
              ),

            CategorySaveButton(
              categoryId: categoryId,
              titleController: titleController,
              descriptionController: descriptionController,
              makeAsParent: makeAsParent,
              selectedParentCategory: selectedParentCategory,
              icon: icon,
              iconType: iconType,
              iconBackground: iconBackground,
              isEditingParent: isEditingParent,
            ),
            if (isEditing)
              CategoryDeleteButton(
                categoryFuture: categoryFuture,
                categoryId: categoryId,
              ),
          ],
        ),
      ),
    );
  }
}
