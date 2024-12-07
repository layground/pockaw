import 'package:flutter/material.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';

class OutlinedIconButton extends IconButton {
  OutlinedIconButton({
    Key? key,
    required GestureTapCallback onPressed,
    required IconData icon,
    bool showBadge = false,
  }) : super(
          key: key,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(AppSpacing.spacing8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              side: const BorderSide(
                color: AppColors.primary,
              ),
            ),
          ),
          icon: Stack(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 18,
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

  static Widget _badge() => Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.red200,
        ),
      );
}
