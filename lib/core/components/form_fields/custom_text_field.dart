import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
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
    super.autofocus,
    super.maxLength,
    super.minLines,
    super.maxLines,
    super.onChanged,
    super.onTap,
    BuildContext? context,
    bool isRequired = false,
    Widget? customCounter,
    String? customCounterText,
    String? hint,
    String? label,
    List<List<dynamic>>? prefixIcon,
    List<List<dynamic>>? suffixIcon,
    GestureTapCallback? onTapSuffixIcon,
  }) : super(
         style: AppTextStyles.body3,
         decoration: InputDecoration(
           hintText: hint,
           label: label == null
               ? const SizedBox()
               : Padding(
                   padding: const EdgeInsets.only(top: 6),
                   child: Row(
                     children: [
                       Text(label, style: AppTextStyles.body3),
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
           fillColor: onTap != null ? context?.purpleButtonBackground : null,
           floatingLabelAlignment: FloatingLabelAlignment.start,
           floatingLabelBehavior: FloatingLabelBehavior.always,
           counter: customCounter,
           counterText: customCounterText,
           border: customBorder(asButton: onTap != null, context: context),
           enabledBorder: customBorder(
             asButton: onTap != null,
             context: context,
           ),
           focusedBorder:
               customBorder(asButton: onTap != null, context: context).copyWith(
                 borderSide: onTap != null
                     ? null
                     : const BorderSide(color: AppColors.purple),
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
                   child: HugeIcon(icon: prefixIcon, size: 24),
                 ),
           suffixIcon: suffixIcon == null
               ? null
               : InkWell(
                   onTap: onTapSuffixIcon,
                   child: Container(
                     margin: const EdgeInsets.only(right: AppSpacing.spacing8),
                     padding: const EdgeInsets.symmetric(
                       horizontal: AppSpacing.spacing12,
                     ),
                     child: HugeIcon(
                       icon: suffixIcon,
                       color: AppColors.neutral200,
                       size: 24,
                     ),
                   ),
                 ),
         ),
       );

  static CustomInputBorder customBorder({
    BuildContext? context,
    bool asButton = false,
  }) => CustomInputBorder(
    borderSide: BorderSide(
      color: !asButton
          ? AppColors.neutral600
          : context?.purpleButtonBorder ?? AppColors.purple,
    ),
    borderRadius: BorderRadius.circular(AppSpacing.spacing8),
  );
}
