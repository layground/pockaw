import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/screen_utils_extensions.dart';
import 'package:pockaw/features/reports/presentation/riverpod/filtered_transactions_provider.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part '../components/spending_by_category_chart.dart';

class BasicMonthlyReportScreen extends ConsumerWidget {
  const BasicMonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = GoRouterState.of(context).extra as DateTime;

    return CustomScaffold(
      context: context,
      title: '${date.toMonthName()} Report',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing20),
        children: [SpendingByCategoryChart(date: date)],
      ),
    );
  }
}
