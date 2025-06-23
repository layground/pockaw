import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';

enum IconSize {
  large,
  medium,
  small,
  tiny,
}

class CustomIconButton extends IconButton {
  CustomIconButton({
    Key? key,
    required GestureTapCallback onPressed,
    required Widget iconWidget,
    Color? backgroundColor,
    Color? borderColor,
    Color? color,
    bool showBadge = false,
    IconSize iconSize = IconSize.medium,
    VisualDensity visualDensity = VisualDensity.standard,
  }) : super(
          key: key,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: backgroundColor ?? AppColors.purple50,
            visualDensity: visualDensity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              side: BorderSide(color: borderColor ?? AppColors.purpleAlpha10),
            ),
          ),
          icon: Stack(
            children: [
              color != null && iconWidget is Icon
                  ? Icon(
                      (iconWidget as Icon).icon,
                      color: color,
                      size: _getIconSize(iconSize),
                    )
                  : SizedBox(
                      width: _getIconSize(iconSize),
                      height: _getIconSize(iconSize),
                      child: FittedBox(
                        child: iconWidget,
                      ),
                    ),
              !showBadge
                  ? const SizedBox()
                  : Positioned(
                      top: 3,
                      right: 3,
                      child: _badge(),
                    )
            ],
          ),
        );

  static double _getIconSize(IconSize size) => switch (size) {
        IconSize.large => 26,
        IconSize.medium => 22,
        IconSize.small => 18,
        IconSize.tiny => 14,
      };

  static Widget _badge() => Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.red,
        ),
      );
}
