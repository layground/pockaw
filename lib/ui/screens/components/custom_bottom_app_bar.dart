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
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            spreadRadius: 0,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.home,
            backgroundColor: AppColors.secondaryAlpha10,
            foregroundColor: AppColors.secondary,
            onTap: () {},
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.plus,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.light,
            onTap: () {},
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.receipt,
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.primary500,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
