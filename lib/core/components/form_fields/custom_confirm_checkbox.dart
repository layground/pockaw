import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class CustomConfirmCheckbox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool checked;
  const CustomConfirmCheckbox({
    super.key,
    required this.title,
    this.subtitle,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Row(
        children: [
          CustomIconButton(
            onPressed: () {},
            icon: checked
                ? HugeIcons.strokeRoundedCheckmarkSquare01
                : HugeIcons.strokeRoundedSquare,
          ),
          const Gap(AppSpacing.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body3,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.body5,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
