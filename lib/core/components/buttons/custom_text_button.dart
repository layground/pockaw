import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class CustomTextButton extends TextButton {
  CustomTextButton({
    super.key,
    required super.onPressed,
    required String label,
    EdgeInsetsGeometry? padding,
    Widget? icon,
    Color? textColor,
  }) : super(
         style: TextButton.styleFrom(
           padding: padding,
           minimumSize: Size.zero,
           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
           alignment: Alignment.centerLeft,
         ),
         child: icon != null
             ? Row(
                 mainAxisSize: MainAxisSize.min,
                 spacing: AppSpacing.spacing8,
                 children: [
                   icon,
                   Text(
                     label,
                     style: AppTextStyles.body3.semibold.copyWith(
                       color: textColor,
                     ),
                   ),
                 ],
               )
             : Text(
                 label,
                 style: AppTextStyles.body3.semibold.copyWith(
                   color: textColor,
                 ),
               ),
       );
}
