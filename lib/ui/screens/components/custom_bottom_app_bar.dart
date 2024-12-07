import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/widgets/buttons/circle_button.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spacing12,
        horizontal: AppSpacing.spacing16,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: AppColors.darkAlpha30,
            offset: Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.home,
            backgroundColor: AppColors.tertiaryAlpha20,
            foregroundColor: AppColors.secondary200,
            onTap: () {},
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.plus,
            backgroundColor: AppColors.tertiary300,
            foregroundColor: AppColors.primary,
            onTap: () {},
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.receipt,
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.secondary200,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
