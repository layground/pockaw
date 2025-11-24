import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/main/presentation/riverpod/main_page_view_riverpod.dart';

class MobileBottomAppBar extends ConsumerWidget {
  final PageController pageController;
  const MobileBottomAppBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color backgroundColor = !context.isDarkMode
        ? AppColors.light.withAlpha(80)
        : AppColors.darkGrey.withAlpha(80);

    final Color borderColor = !context.isDarkMode
        ? Colors.grey.shade200
        : Colors.white12;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.spacing12,
            horizontal: AppSpacing.spacing16,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleIconButton(
                radius: 25,
                icon: HugeIconsStrokeRounded.home01,
                backgroundColor: Colors.transparent,
                foregroundColor: ref
                    .read(pageControllerProvider.notifier)
                    .getIconColor(context, 0),
                onTap: () {
                  pageController.jumpToPage(0);
                },
              ),
              CircleIconButton(
                radius: 25,
                icon: HugeIcons.strokeRoundedReceiptDollar,
                backgroundColor: Colors.transparent,
                foregroundColor: ref
                    .read(pageControllerProvider.notifier)
                    .getIconColor(context, 1),
                onTap: () {
                  pageController.jumpToPage(1);
                },
              ),
              CircleIconButton(
                radius: 25,
                icon: HugeIcons.strokeRoundedPlusSign,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.light,
                onTap: () {
                  context.push(Routes.transactionForm);
                },
              ),
              CircleIconButton(
                radius: 25,
                icon: HugeIcons.strokeRoundedTarget01,
                backgroundColor: Colors.transparent,
                foregroundColor: ref
                    .read(pageControllerProvider.notifier)
                    .getIconColor(context, 2),
                onTap: () {
                  pageController.jumpToPage(2);
                },
              ),
              CircleIconButton(
                radius: 25,
                icon: HugeIcons.strokeRoundedMoneyBag02,
                backgroundColor: Colors.transparent,
                foregroundColor: ref
                    .read(pageControllerProvider.notifier)
                    .getIconColor(context, 3),
                onTap: () {
                  pageController.jumpToPage(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
