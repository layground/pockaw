import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pockaw/ui/screens/budget/budget_screen.dart';
import 'package:pockaw/ui/screens/components/custom_bottom_app_bar.dart';
import 'package:pockaw/ui/screens/goal/goal_screen.dart';
import 'package:pockaw/ui/screens/home_screen/home_screen.dart';
import 'package:pockaw/ui/screens/transaction/transaction_screen.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
            children: [
              HomeScreen(),
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
