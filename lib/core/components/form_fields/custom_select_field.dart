import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
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
          suffixIcon: TablerIcons.chevron_right,
          readOnly: true,
        );
}
