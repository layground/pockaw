import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
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
    final pageController = PageController(initialPage: currentPage);
    return Material(
      child: Stack(
        children: [
          PageView(
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
          ),
          Positioned(
            bottom: 20,
            left: AppSpacing.spacing16,
            right: AppSpacing.spacing16,
            child: CustomBottomAppBar(pageController: pageController),
          ),
        ],
      ),
    );
  }
}
