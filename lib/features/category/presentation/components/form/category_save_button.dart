part of '../../screens/category_form_screen.dart';

class CategorySaveButton extends ConsumerWidget {
  const CategorySaveButton({
    super.key,
    required this.categoryId,
    required this.titleController,
    required this.descriptionController,
    required this.makeAsParent,
    required this.selectedParentCategory,
    required this.icon,
    required this.isEditingParent,
  });

  final int? categoryId;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ValueNotifier<bool> makeAsParent;
  final CategoryModel? selectedParentCategory;
  final ValueNotifier<String> icon;
  final bool isEditingParent;

  @override
  Widget build(BuildContext context, ref) {
    return PrimaryButton(
      label: 'Save',
      state: ButtonState.active,
      onPressed: () async {
        final newCategory = CategoryModel(
          id: categoryId,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          parentId: makeAsParent.value ? null : selectedParentCategory?.id,
          icon: icon.value,
        );

        CategoryFormService().save(
          context,
          ref,
          newCategory,
          isEditingParent: isEditingParent,
        );
      },
    );
  }
}
