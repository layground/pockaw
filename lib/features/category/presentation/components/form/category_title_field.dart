part of '../../screens/category_form_screen.dart';

class CategoryTitleField extends ConsumerWidget {
  const CategoryTitleField({super.key, required this.titleController});

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context, ref) {
    return CustomTextField(
      context: context,
      controller: titleController, // Use the controller
      label: 'Title (max. 25)',
      hint: 'New Category Title',
      isRequired: true,
      prefixIcon: HugeIcons.strokeRoundedTextSmallcaps,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      maxLength: 25,
      customCounterText: '',
    );
  }
}
