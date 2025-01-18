import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/router/app_router.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/router/routes.dart';

class CustomBottomAppBar extends StatefulWidget {
  final PageController pageController;
  const CustomBottomAppBar({super.key, required this.pageController});

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
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
            backgroundColor: AppColors.secondaryAlpha50,
            foregroundColor: AppColors.secondary200,
            onTap: () {
              widget.pageController.jumpToPage(0);
              setState(() {});
            },
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.receipt,
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.secondary300,
            onTap: () {
              widget.pageController.jumpToPage(1);
              setState(() {});
            },
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.plus,
            backgroundColor: AppColors.tertiary300,
            foregroundColor: AppColors.primary,
            onTap: () {
              context.push(Routes.transactionForm);
            },
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.target_arrow,
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.secondary300,
            onTap: () {
              widget.pageController.jumpToPage(2);
              setState(() {});
            },
          ),
          CircleIconButton(
            radius: 28,
            icon: TablerIcons.database_dollar,
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.secondary300,
            onTap: () {
              widget.pageController.jumpToPage(3);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
