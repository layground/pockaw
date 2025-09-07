part of '../../screens/category_form_screen.dart';

class CategoryDeleteButton extends ConsumerWidget {
  const CategoryDeleteButton({
    super.key,
    required this.categoryFuture,
    required this.categoryId,
  });

  final AsyncSnapshot<Category?> categoryFuture;
  final int? categoryId;

  @override
  Widget build(BuildContext context, ref) {
    return TextButton(
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
              final categories = ref.read(hierarchicalCategoriesProvider).value;

              CategoryModel categoryModel = categoryFuture.data!.toModel();

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
    );
  }
}
