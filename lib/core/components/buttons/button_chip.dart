import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class ButtonChip extends StatelessWidget {
  final String label;
  final bool active;
  final GestureTapCallback? onTap;
  const ButtonChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      child: Container(
        decoration: BoxDecoration(
          color: active ? context.purpleBackground : null,
          border: Border.all(
            color: active
                ? context.purpleBorderLighter
                : context.secondaryBorderLighter,
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spacing8,
          AppSpacing.spacing8,
          AppSpacing.spacing12,
          AppSpacing.spacing8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HugeIcon(
              icon: active
                  ? HugeIcons.strokeRoundedCheckmarkCircle02
                  : HugeIcons.strokeRoundedCircle,
              color: active ? context.purpleIcon : null,
            ),
            const Gap(AppSpacing.spacing8),
            Text(
              label,
              style: AppTextStyles.body3.copyWith(
                color: active ? context.purpleText : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
