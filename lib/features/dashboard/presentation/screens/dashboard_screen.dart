import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/progress_indicators/custom_progress_indicator.dart';
import 'package:pockaw/core/components/progress_indicators/custom_progress_indicator_legend.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_font_weights.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';

part '../components/action_button.dart';
part '../components/balance_card.dart';
part '../components/cash_flow_cards.dart';
part '../components/goals_carousel.dart';
part '../components/greeting_card.dart';
part '../components/header.dart';
part '../components/recent_transaction_list.dart';
part '../components/spending_progress_chart.dart';
part '../components/transaction_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Header(),
          Container(
            margin: const EdgeInsets.all(AppSpacing.spacing20),
            child: const Column(
              children: [
                BalanceCard(),
                Gap(AppSpacing.spacing12),
                CashFlowCards(),
                Gap(AppSpacing.spacing12),
                SpendingProgressChart()
              ],
            ),
          ),
          const GoalsCarousel(),
          const RecentTransactionList(),
        ],
      ),
    );
  }
}
