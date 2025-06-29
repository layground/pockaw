import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class SecondaryButton extends OutlinedButton {
  SecondaryButton({
    super.key,
    required BuildContext context,
    required super.onPressed,
    String? label,
    IconData? icon,
  }) : super(
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             if (icon != null) Icon(icon, size: 22),
             if (label != null) const Gap(AppSpacing.spacing8),
             if (label != null)
               Padding(
                 padding: const EdgeInsets.only(top: 1),
                 child: Text(label, style: AppTextStyles.body3.semibold),
               ),
           ],
         ),
       );
}
