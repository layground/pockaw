part of '../../screens/category_form_screen.dart';

class CategoryDescriptionField extends StatelessWidget {
  const CategoryDescriptionField({
    super.key,
    required this.descriptionController,
  });

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      context: context,
      label: 'Description (max. 50)',
      hint: 'Write simple description...',
      controller: descriptionController, // Use the controller
      prefixIcon: HugeIcons.strokeRoundedNote,
      minLines: 1,
      maxLines: 3,
      maxLength: 50,
      customCounterText: '',
    );
  }
}
