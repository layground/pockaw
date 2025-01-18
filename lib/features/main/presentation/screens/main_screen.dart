import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/budget/presentation/screens/budget_screen.dart';
import 'package:pockaw/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:pockaw/features/goal/presentation/screens/goal_screen.dart';
import 'package:pockaw/features/main/presentation/components/custom_bottom_app_bar.dart';
import 'package:pockaw/features/transaction/presentation/screens/transaction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              log('$value', name: 'page');
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
            child: CustomBottomAppBar(
              pageController: _pageController,
            ),
          ),
        ],
      ),
    );
  }
}
