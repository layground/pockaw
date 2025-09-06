part of '../../screens/category_form_screen.dart';

class CategoryPickerField extends ConsumerWidget {
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
  Widget build(BuildContext context, ref) {
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
                color: context.purpleBackground(context.themeMode),
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                border: Border.all(
                  color: context.purpleBorderLighter(context.themeMode),
                ),
              ),
              child: Center(
                child: icon.value.isEmpty
                    ? Icon(HugeIcons.strokeRoundedPizza01, size: 30)
                    : Image.asset(icon.value),
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
                  : selectedParentCategory?.title ?? 'Leave empty for parent',
              prefixIcon: HugeIcons.strokeRoundedStructure01,
              onTap: () async {
                // Navigate to the picker screen and wait for a result
                final result = await context.push(
                  Routes.categoryListPickingParent,
                );
                // If a category was selected and returned, update the provider
                if (result != null && result is CategoryModel) {
                  ref.read(selectedParentCategoryProvider.notifier).state =
                      result;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
