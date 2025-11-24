import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/reports/data/models/category_chart_model.dart';
import 'package:pockaw/features/reports/presentation/components/weekly_income_vs_expense_chart.dart';
import 'package:pockaw/features/reports/presentation/riverpod/filtered_transactions_provider.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/reports/presentation/riverpod/pie_chart_touch_index.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';

part '../components/spending_pie_chart.dart';

class BasicMonthlyReportScreen extends ConsumerWidget {
  const BasicMonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = GoRouterState.of(context).extra as DateTime;
    final transactionsAsync = ref.watch(monthlyTransactionsProvider(date));

    return CustomScaffold(
      context: context,
      title: '${date.toMonthName()} Report',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing20),
        children: [
          SpendingPieChart(
            expenseData: transactionsAsync.value?.chartDataList ?? [],
            totalExpenses: transactionsAsync.value?.totalExpenses ?? 0,
            isLoading: transactionsAsync.isLoading,
          ),
          Gap(AppSpacing.spacing20),
          WeeklyIncomeExpenseChart(),
        ],
      ),
    );
  }
}
