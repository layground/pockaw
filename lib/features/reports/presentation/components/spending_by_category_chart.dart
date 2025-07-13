import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpendingByCategoryChart extends ConsumerWidget {
  const SpendingByCategoryChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For this example, we'll watch all transactions.
    // In a real app, you'd filter this by the current month.
    final transactionsAsync = ref.watch(transactionListProvider);

    return transactionsAsync.when(
      data: (transactions) {
        final expenseData = _processData(transactions);

        if (expenseData.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No expense data for this period.',
                style: AppTextStyles.body3,
              ),
            ),
          );
        }

        final totalExpenses = expenseData.fold(
          0.0,
          (sum, item) => sum + item.amount,
        );

        return SfCircularChart(
          title: ChartTitle(
            text: 'Spending by Category',
            textStyle: AppTextStyles.body2,
          ),
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom,
            textStyle: AppTextStyles.body4,
          ),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Spent',
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.neutral400,
                    ),
                  ),
                  Text(
                    totalExpenses.toPriceFormat(),
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
            ),
          ],
          series: <CircularSeries>[
            DoughnutSeries<_ChartData, String>(
              dataSource: expenseData,
              xValueMapper: (_ChartData data, _) => data.category,
              yValueMapper: (_ChartData data, _) => data.amount,
              dataLabelMapper: (datum, index) => datum.amount.toPriceFormat(),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Display percentage on slices
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: AppTextStyles.body4,
              ),
              innerRadius: '70%', // This creates the donut shape
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        height: 200,
        child: Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }

  List<_ChartData> _processData(List<TransactionModel> transactions) {
    final Map<String, double> categoryExpenses = {};

    for (var transaction in transactions) {
      if (transaction.transactionType == TransactionType.expense) {
        final categoryName = transaction.category.title;
        categoryExpenses.update(
          categoryName,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }

    return categoryExpenses.entries
        .map((entry) => _ChartData(entry.key, entry.value))
        .toList();
  }
}

class _ChartData {
  _ChartData(this.category, this.amount);
  final String category;
  final double amount;
}
