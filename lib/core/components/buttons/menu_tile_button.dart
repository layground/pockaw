import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class MenuTileButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData? suffixIcon;
  final GestureTapCallback? onTap;
  const MenuTileButton({
    super.key,
    required this.label,
    required this.icon,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: AppColors.secondary50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radius8),
        side: const BorderSide(
          color: AppColors.secondaryAlpha10,
        ),
      ),
      title: Text(
        label,
        style: AppTextStyles.body3,
      ),
      leading: Icon(
        icon,
      ),
      trailing: Icon(
        suffixIcon ?? HugeIcons.strokeRoundedArrowRight01,
        color: AppColors.secondaryAlpha50,
        size: 20,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing4,
        AppSpacing.spacing12,
        AppSpacing.spacing4,
      ),
    );
  }
}
