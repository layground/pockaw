import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_app_bar.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_balance_card.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_cash_flow.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_my_spending.dart';
import 'package:pockaw/ui/screens/home_screen/components/my_goals_carousel.dart';
import 'package:pockaw/ui/screens/home_screen/components/recent_transaction_list.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const HomeAppBar(),
          Container(
            margin: const EdgeInsets.all(AppSpacing.spacing20),
            child: const Column(
              children: [
                HomeBalanceCard(),
                Gap(AppSpacing.spacing12),
                HomeCashFlow(),
                Gap(AppSpacing.spacing12),
                HomeMySpending()
              ],
            ),
          ),
          const MyGoalsCarousel(),
          const RecentTransactionList(),
        ],
      ),
    );
  }
}
