import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class MenuTileButton extends StatelessWidget {
  final String label;
  final Widget? subtitle;
  final List<List<dynamic>> icon;
  final List<List<dynamic>>? suffixIcon;
  final bool disabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const MenuTileButton({
    super.key,
    required this.label,
    required this.icon,
    this.subtitle,
    this.suffixIcon,
    this.disabled = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      tileColor: disabled
          ? context.disabledTileBackground
          : context.purpleBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        // Use context.colors.outline or a custom color that adapts
        side: BorderSide(color: context.purpleBorderLighter),
      ),
      title: Text(
        label,
        style: AppTextStyles.body3.copyWith(color: context.colors.onSurface),
      ), // Ensure text color adapts
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              style: AppTextStyles.body4.copyWith(
                color: disabled
                    ? context.disabledTileForeground
                    : context.placeholderForeground,
              ), // Subtitle color
              child: subtitle!,
            )
          : null,
      leading: HugeIcon(
        icon: icon,
        color: disabled ? context.disabledTileForeground : context.purpleIcon,
      ), // Leading icon uses primary color
      trailing: HugeIcon(
        icon: suffixIcon ?? HugeIcons.strokeRoundedArrowRight01,
        color: disabled
            ? context.disabledTileForeground
            : context.isDarkMode
            ? context.colors.onSurfaceVariant
            : AppColors.purpleAlpha50,
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
