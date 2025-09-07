part of '../../screens/category_form_screen.dart';

class CategoryPickerField extends StatelessWidget {
  const CategoryPickerField({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconType,
    required this.parentCategoryController,
    required this.isEditingParent,
    required this.selectedParentCategory,
  });

  final ValueNotifier<String> icon;
  final ValueNotifier<String> iconBackground;
  final ValueNotifier<IconType> iconType;
  final TextEditingController parentCategoryController;
  final bool isEditingParent;
  final CategoryModel? selectedParentCategory;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              context.openBottomSheet(
                child: CategoryIconDialog(
                  icon: icon,
                  iconBackground: iconBackground,
                  iconType: iconType,
                ),
              );
            },
            child: Container(
              height: 66,
              width: 66,
              padding: const EdgeInsets.all(AppSpacing.spacing8),
              decoration: BoxDecoration(
                color: context.purpleBackground,
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                border: Border.all(color: context.purpleBorderLighter),
              ),
              child: Center(
                child: CategoryIcon(
                  iconType: iconType.value,
                  icon: icon.value,
                  iconBackground: iconBackground.value,
                ),
              ),
            ),
          ),
          const Gap(AppSpacing.spacing8),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                return CustomSelectField(
                  context: context,
                  controller: parentCategoryController,
                  label: 'Parent Category',
                  hint: isEditingParent
                      ? '-'
                      : selectedParentCategory?.title ??
                            'Leave empty for parent',
                  prefixIcon: HugeIcons.strokeRoundedStructure01,
                  onTap: () async {
                    // Navigate to the picker screen and wait for a result
                    final result = await context.push<CategoryModel>(
                      Routes.categoryListPickingParent,
                    );
                    // If a category was selected and returned, update the provider
                    if (result != null) {
                      ref.read(selectedParentCategoryProvider.notifier).state =
                          result;
                      parentCategoryController.text = result.title;
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
