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
    required IconData icon,
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
              Icon(
                icon,
                color: color ?? AppColors.purple,
                size: _getIconSize(iconSize),
              ),
              !showBadge
                  ? const SizedBox()
                  : Positioned(
                      top: 2,
                      right: 2,
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
