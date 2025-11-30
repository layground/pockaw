import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/reports/presentation/components/money_insider_chart.dart';
import 'package:pockaw/features/reports/presentation/components/six_months_income_vs_expense_chart.dart';

class AnalyticChartReports extends StatelessWidget {
  const AnalyticChartReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.spacing16,
        children: [
          const Text('Analytic Chart Reports', style: AppTextStyles.heading6),
          const MoneyInsiderChart(),
          const SixMonthsIncomeExpenseChart(),
        ],
      ),
    );
  }
}
