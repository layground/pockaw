import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/progress_indicators/custom_progress_indicator.dart';
import 'package:pockaw/core/components/progress_indicators/custom_progress_indicator_legend.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_font_weights.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';
import 'package:pockaw/features/wallet_switcher/presentation/screens/wallet_switcher_dropdown.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transactions_list_provider.dart';

part '../components/action_button.dart';
part '../components/balance_card.dart';
part '../components/cash_flow_cards.dart';
part '../components/greeting_card.dart';
part '../components/header.dart';
// part '../components/my_goals/goals_carousel.dart';
part '../components/recent_transaction_list.dart';
part '../components/spending_progress_chart.dart';
part '../components/transaction_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsListProvider);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(85),
        child: Header(),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              0,
              AppSpacing.spacing20,
              AppSpacing.spacing20,
            ),
            child: Column(
              children: [
                const BalanceCard(),
                const Gap(AppSpacing.spacing12),
                transactionsAsync.when(
                  data: (transactions) {
                    final income = transactions
                        .where((t) => t.transactionType == 'income')
                        .fold<double>(0, (sum, t) => sum + (t.amount));
                    final expense = transactions
                        .where((t) => t.transactionType == 'expense')
                        .fold<double>(0, (sum, t) => sum + (t.amount));
                    return CashFlowCards(income: income, expense: expense);
                  },
                  loading: () => const SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator())),
                  error: (e, st) => SizedBox(
                      height: 80, child: Center(child: Text('Error: $e'))),
                ),
                const Gap(AppSpacing.spacing12),
                const SpendingProgressChart()
              ],
            ),
          ),
          // const MyGoalsCarousel(),
          transactionsAsync.when(
            data: (transactions) => RecentTransactionList(
              transactions: transactions.reversed.take(5).toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }
}
