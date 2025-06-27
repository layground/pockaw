import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class MenuTileButton extends StatelessWidget {
  final String label;
  final Widget? subtitle;
  final IconData icon;
  final IconData? suffixIcon;
  final GestureTapCallback? onTap;
  const MenuTileButton({
    super.key,
    required this.label,
    required this.icon,
    this.subtitle,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      // Use colorScheme.surface or a custom color that adapts
      tileColor: isDarkMode
          ? colorScheme.surfaceContainerHighest
          : AppColors.secondary50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radius8),
        // Use colorScheme.outline or a custom color that adapts
        side: BorderSide(
          color: isDarkMode ? colorScheme.outline : AppColors.secondaryAlpha10,
        ),
      ),
      title: Text(
        label,
        style: AppTextStyles.body3.copyWith(color: colorScheme.onSurface),
      ), // Ensure text color adapts
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              style: AppTextStyles.body3.copyWith(
                color: colorScheme.onSurfaceVariant,
              ), // Subtitle color
              child: subtitle!,
            )
          : null,
      leading: Icon(
        icon,
        color: colorScheme.primary,
      ), // Leading icon uses primary color
      trailing: Icon(
        suffixIcon ?? HugeIcons.strokeRoundedArrowRight01,
        color: isDarkMode
            ? colorScheme.onSurfaceVariant.withAlpha(50)
            : AppColors
                  .secondaryAlpha50, // Example: secondaryAlpha50 for light, onSurfaceVariant for dark
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
