import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/form_fields/custom_input_border.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class CustomTextField extends TextField {
  CustomTextField({
    super.key,
    super.controller,
    super.focusNode,
    super.keyboardType,
    super.textInputAction,
    super.inputFormatters,
    super.readOnly,
    super.minLines,
    super.maxLines,
    super.onChanged,
    super.onTap, // treat as a button if this not null
    bool isRequired = false,
    String? hint,
    String? label,
    IconData? prefixIcon,
    IconData? suffixIcon,
  }) : super(
          style: AppTextStyles.body3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body3.copyWith(
              color: AppColors.neutral300,
            ),
            label: label == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Text(
                          label,
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.neutral600,
                          ),
                        ),
                        if (isRequired) const Gap(AppSpacing.spacing4),
                        if (isRequired)
                          Text(
                            '*',
                            style: AppTextStyles.body3.copyWith(
                              color: AppColors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
            filled: true,
            fillColor: onTap != null ? AppColors.purple50 : AppColors.neutral50,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: customBorder(asButton: onTap != null),
            enabledBorder: customBorder(asButton: onTap != null),
            focusedBorder: customBorder(asButton: onTap != null).copyWith(
              borderSide: onTap != null
                  ? null
                  : const BorderSide(
                      color: AppColors.purple,
                    ),
            ),
            alignLabelWithHint: label != null,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(
              prefixIcon == null ? AppSpacing.spacing20 : 0,
              AppSpacing.spacing16,
              0,
              AppSpacing.spacing16,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Container(
                    margin: const EdgeInsets.only(left: AppSpacing.spacing8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing12,
                    ),
                    child: Icon(
                      prefixIcon,
                      color: AppColors.neutral700,
                      size: 24,
                    ),
                  ),
            suffixIcon: suffixIcon == null
                ? null
                : Container(
                    margin: const EdgeInsets.only(right: AppSpacing.spacing8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing12,
                    ),
                    child: Icon(
                      suffixIcon,
                      color: AppColors.neutral200,
                      size: 24,
                    ),
                  ),
          ),
        );

  static CustomInputBorder customBorder({bool asButton = false}) =>
      CustomInputBorder(
        borderSide: BorderSide(
          color: !asButton ? AppColors.neutralAlpha50 : AppColors.purpleAlpha10,
        ),
        borderRadius: BorderRadius.circular(
          AppSpacing.spacing8,
        ),
      );
}
