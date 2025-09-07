part of '../screens/basic_monthly_report_screen.dart';

class SpendingByCategoryChart extends ConsumerWidget {
  final DateTime date;
  const SpendingByCategoryChart({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch transactions filtered by the given month
    final transactionsAsync = ref.watch(monthlyTransactionsProvider(date));

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

        return Container(
          height: context.screenSize.height * 0.5,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            color: context.purpleBackground,
            borderRadius: BorderRadius.circular(AppRadius.radius12),
          ),
          child: Column(
            spacing: AppSpacing.spacing12,
            children: [
              Expanded(
                child: SfCircularChart(
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
                            totalExpenses.toShortPriceFormat(),
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
                      dataLabelMapper: (datum, index) =>
                          datum.amount.toShortPriceFormat(),
                      animationDuration: 500,
                      groupMode: CircularChartGroupMode.point,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        // Display percentage on slices
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: AppTextStyles.body4,
                      ),
                      innerRadius: '70%', // This creates the donut shape
                    ),
                  ],
                ),
              ),
              Text(
                'Toggle legend items to show/hide categories.',
                style: AppTextStyles.body4,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
