import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/screen_utils_extensions.dart';
import 'package:pockaw/features/budget/presentation/screens/budget_screen.dart';
import 'package:pockaw/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_screen.dart';
import 'package:pockaw/features/main/presentation/components/custom_bottom_app_bar.dart';
import 'package:pockaw/features/main/presentation/riverpod/main_page_view_riverpod.dart';
import 'package:pockaw/features/transaction/presentation/screens/transaction_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currentPage = ref.watch(pageControllerProvider);
    // It's generally recommended to create PageController outside build or use usePageController hook if stateful,
    // but for this structure, ensure it's stable or managed by a provider if complex interactions are needed.
    // For this specific case where it's driven by Riverpod's currentPage, it's acceptable.
    final pageController = PageController(initialPage: currentPage);

    final Widget pageViewWidget = PageView(
      controller: pageController,
      onPageChanged: (value) {
        ref.read(pageControllerProvider.notifier).setPage(value);
      },
      children: const [
        DashboardScreen(),
        TransactionScreen(),
        GoalScreen(),
        BudgetScreen(),
      ],
    );

    final Widget navigationControls = CustomBottomAppBar(
      pageController: pageController,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Material(
        child: context.isDesktopLayout
            ? Row(
                children: [
                  navigationControls, // This will render as a sidebar
                  Expanded(child: pageViewWidget),
                ],
              )
            : Stack(
                children: [
                  pageViewWidget,
                  Positioned(
                    bottom: AppSpacing.spacing8,
                    left: AppSpacing.spacing16,
                    right: AppSpacing.spacing16,
                    child: navigationControls,
                  ),
                ],
              ),
      ),
    );
  }
}
