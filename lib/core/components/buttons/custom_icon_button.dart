import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

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
    Color? color,
    bool showBadge = false,
    IconSize iconSize = IconSize.medium,
  }) : super(
          key: key,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(AppSpacing.spacing8),
            backgroundColor: color ?? AppColors.purple50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              side: const BorderSide(
                color: AppColors.purpleAlpha10,
              ),
            ),
          ),
          icon: Stack(
            children: [
              Icon(
                icon,
                color: AppColors.purple800,
                size: _getIconSize(iconSize),
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
        // TODO: Handle this case.
        IconSize.large => 26,
        // TODO: Handle this case.
        IconSize.medium => 22,
        // TODO: Handle this case.
        IconSize.small => 18,
        // TODO: Handle this case.
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
