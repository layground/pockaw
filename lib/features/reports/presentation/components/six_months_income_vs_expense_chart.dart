import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pockaw/core/components/charts/chart_container.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/features/reports/data/models/monthly_financial_summary_model.dart';
import 'package:pockaw/features/reports/presentation/riverpod/financial_health_provider.dart';

class SixMonthsIncomeExpenseChart extends ConsumerWidget {
  const SixMonthsIncomeExpenseChart({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final touchedIndex = ref.watch(barChartTouchIndexProvider);
    // final touchedIndexState = ref.read(barChartTouchIndexProvider.notifier);
    final summaryAsync = ref.watch(sixMonthSummaryProvider);

    return ChartContainer(
      title: 'Income vs. Expense',
      subtitle: 'Last 6 Months',
      height: 300,
      chart: summaryAsync.when(
        data: (data) => _buildChart(context, data, ref),
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(child: Text('Error loading data: $err')),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<MonthlyFinancialSummary> data,
    WidgetRef ref,
  ) {
    if (data.isEmpty || data.every((e) => e.income == 0 && e.expense == 0)) {
      return const Center(child: Text('No transaction data available yet.'));
    }

    // Calculate max Y to give some headroom
    double maxY = 0;
    for (var item in data) {
      if (item.income > maxY) maxY = item.income;
      if (item.expense > maxY) maxY = item.expense;
    }
    // Add 20% buffer
    maxY = maxY * 1.2;
    if (maxY == 0) maxY = 100;

    // Ensure maxX > minX to prevent chart errors with single data points.
    final double rawMaxX = (data.length - 1).toDouble();
    final double maxX = rawMaxX <= 0 ? 1.0 : rawMaxX;

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => context.secondaryBackgroundSolid,
            tooltipBorder: BorderSide(color: context.purpleBorderLighter),
            tooltipBorderRadius: BorderRadius.circular(AppRadius.radius4),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;

                String label = barSpot.barIndex == 0 ? 'Income' : 'Expense';
                Color color = barSpot.barIndex == 0
                    ? Colors.greenAccent[700]!
                    : Colors.redAccent[400]!;

                // Custom tooltip content
                return LineTooltipItem(
                  '$label: ${flSpot.y.toPriceFormat()}',
                  AppTextStyles.body3.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
            // Customize tooltip background color based on context if needed
            // tooltipBgColor: Colors.blueGrey,
          ),
          handleBuiltInTouches: true,
        ),

        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4, // 4 grid lines roughly
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withAlpha(20),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1, // Ensure we show a title for each interval (week)
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('MMM').format(data[index].month),
                    style: AppTextStyles.body4.bold,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 4, // Match grid interval
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  NumberFormat.compact().format(value),
                  style: AppTextStyles.body4,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          // Income Line (Green)
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.income);
            }).toList(),
            isCurved: true,
            color: Colors.greenAccent[700],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true), // Show dots on data points
            belowBarData: BarAreaData(
              show: true,
              color: Colors.greenAccent[700]!.withAlpha(20), // Light fill
            ),
          ),
          // Expense Line (Red)
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.expense);
            }).toList(),
            isCurved: true,
            color: Colors.redAccent[400],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.redAccent[400]!.withAlpha(20), // Light fill
            ),
          ),
        ],
      ),
    );
  }
}
