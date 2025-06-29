import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/main/presentation/riverpod/main_page_view_riverpod.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class MobileBottomAppBar extends ConsumerWidget {
  final PageController pageController;
  const MobileBottomAppBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spacing12,
        horizontal: AppSpacing.spacing16,
      ),
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.light
            ? AppColors.dark
            : AppColors.darkGrey,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            radius: 25,
            icon: HugeIcons.strokeRoundedHome01,
            backgroundColor: Colors.transparent,
            foregroundColor: ref
                .read(pageControllerProvider.notifier)
                .getIconColor(0),
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
                .getIconColor(1),
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
                .getIconColor(2),
            onTap: () {
              pageController.jumpToPage(2);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: HugeIcons.strokeRoundedDatabase,
            backgroundColor: Colors.transparent,
            foregroundColor: ref
                .read(pageControllerProvider.notifier)
                .getIconColor(3),
            onTap: () {
              pageController.jumpToPage(3);
            },
          ),
        ],
      ),
    );
  }
}
