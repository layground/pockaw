import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class CustomTextButton extends TextButton {
  CustomTextButton({
    super.key,
    required super.onPressed,
    required String label,
    Color? textColor,
  }) : super(
         style: TextButton.styleFrom(
           padding: EdgeInsets.zero,
           minimumSize: Size.zero,
           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
           alignment: Alignment.centerLeft,
         ),
         child: Text(
           label,
           style: AppTextStyles.body3.semibold.copyWith(color: textColor),
         ),
       );
}
