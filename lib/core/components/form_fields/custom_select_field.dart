import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';

class CustomSelectField extends CustomTextField {
  CustomSelectField({
    super.key,
    super.controller,
    super.label,
    super.hint,
    super.prefixIcon,
    super.isRequired,
    super.onTap,
  }) : super(
          suffixIcon: HugeIcons.strokeRoundedArrowRight01,
          readOnly: true,
        );
}
