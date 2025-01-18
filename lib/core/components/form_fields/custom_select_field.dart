import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';

class CustomSelectField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final Color? hintColor;
  final Color? background;
  final IconData? icon;
  final IconData? suffixIcon;

  const CustomSelectField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.hintColor,
    this.background,
    this.icon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      key: key,
      controller: controller,
      label: label,
      background: Colors.white,
      icon: icon,
      hint: hint,
      hintColor: hintColor,
      suffixIcon: suffixIcon ?? TablerIcons.chevron_right,
      border: Border.all(color: AppColors.secondary),
      readOnly: true,
      // hintColor: AppColors.dark,
    );
  }
}
