import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/progress_indicators/custom_progress_indicator.dart';
import 'package:pockaw/core/components/progress_indicators/custom_progress_indicator_legend.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_font_weights.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/extensions/screen_utils_extensions.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:pockaw/features/dashboard/presentation/components/analytic_chart_reports.dart';
import 'package:pockaw/features/goal/presentation/components/goal_pinned_holder.dart';
import 'package:pockaw/features/main/presentation/components/profile_picture.dart';
import 'package:pockaw/features/theme_switcher/presentation/components/theme_mode_switcher.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:pockaw/features/wallet/screens/wallet_form_bottom_sheet.dart';
import 'package:pockaw/features/wallet_switcher/presentation/screens/wallet_switcher_dropdown.dart';

part '../components/action_button.dart';
part '../components/balance_card.dart';
part '../components/wallet_amount_visibility_button.dart';
part '../components/wallet_amount_edit_button.dart';
part '../components/cash_flow_cards.dart';
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
      backgroundColor: context.colors.surface,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(85),
        child: Header(),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 100),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              0,
              AppSpacing.spacing20,
              AppSpacing.spacing20,
            ),
            child: const Column(
              children: [
                BalanceCard(),
                Gap(AppSpacing.spacing12),
                CashFlowCards(),
                Gap(AppSpacing.spacing12),
                SpendingProgressChart(),
              ],
            ),
          ),
          const GoalPinnedHolder(),
          const RecentTransactionList(),
          const AnalyticChartReports(),
        ],
      ),
    );
  }
}
