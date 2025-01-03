import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';

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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(
            AppRadius.radiusFull,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spacing8,
          AppSpacing.spacing8,
          AppSpacing.spacing12,
          AppSpacing.spacing8,
        ),
        child: Row(
          children: [
            Icon(active ? TablerIcons.circle_check_filled : TablerIcons.circle),
            const Gap(AppSpacing.spacing8),
            Text(
              label,
              style: AppTextStyles.body3,
            )
          ],
        ),
      ),
    );
  }
}
