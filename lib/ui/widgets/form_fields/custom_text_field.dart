import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final Color? hintColor;
  final Color? background;
  final IconData? icon;
  final IconData? suffixIcon;
  final BoxBorder? border;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.hintColor,
    this.background,
    this.icon,
    this.suffixIcon,
    this.border,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radius8),
        color: background ?? AppColors.secondary100,
        border: border,
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon ?? TablerIcons.letter_case,
              color: AppColors.secondary800,
            ),
          if (icon != null) const Gap(AppSpacing.spacing12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body5.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
                TextField(
                  controller: controller,
                  style: AppTextStyles.body2,
                  readOnly: readOnly,
                  minLines: minLines,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: background ?? AppColors.secondary100,
                    hintText: hint ?? 'Enter...',
                    hintStyle: AppTextStyles.body2.copyWith(
                      color: hintColor ?? AppColors.primary300,
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          if (suffixIcon == null)
            const SizedBox()
          else
            const Gap(AppSpacing.spacing12),
          if (suffixIcon == null)
            const SizedBox()
          else
            Icon(
              suffixIcon ?? TablerIcons.letter_case,
              color: AppColors.secondary800,
            ),
        ],
      ),
    );
  }
}
