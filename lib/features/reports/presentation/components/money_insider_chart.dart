import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/components/charts/chart_container.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';
import 'package:pockaw/features/reports/data/models/daily_net_flow_model.dart';
import 'package:pockaw/features/reports/presentation/riverpod/financial_health_provider.dart';
import 'dart:math';

class MoneyInsiderChart extends ConsumerWidget {
  const MoneyInsiderChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netFlowAsync = ref.watch(dailyNetFlowProvider);

    return ChartContainer(
      title: 'Money Insider',
      subtitle: 'Daily Net Flow vs. Zero Line (This Month)',
      height: 350, // Taller chart for better visualization
      chart: netFlowAsync.when(
        data: (data) => _buildChart(context, data),
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<DailyNetFlowSummary> data) {
    if (data.isEmpty) {
      return const Center(child: Text('No transactions recorded this month.'));
    }

    // 1. Calculate Min/Max Y values across all data points
    final allValues = data.map((d) => d.netAmount).toList();
    final double absoluteMax = allValues.map((v) => v.abs()).reduce(max);

    // Ensure the Y-axis is symmetric around 0 for clear visualization and to
    // prevent division-by-zero errors on intervals if all data points are zero.
    final double minY;
    final double maxY;
    if (absoluteMax == 0.0) {
      minY = -1.0;
      maxY = 1.0;
    } else {
      minY = -absoluteMax * 1.1;
      maxY = absoluteMax * 1.1;
    }

    final spots = data
        .map((d) => FlSpot(d.day.toDouble(), d.netAmount))
        .toList();
    final currentDay = DateTime.now().day.toDouble();

    return LineChart(
      LineChartData(
        // Set chart boundaries
        minX: 1,
        maxX: data.last.day.toDouble(), // Extends to the last day with data
        minY: minY,
        maxY: maxY,

        // Horizontal guide lines (Zero line and grid)
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0, // The crucial Zero Line
              color: Colors.white,
              strokeWidth: 2,
              dashArray: [10, 5],
              label: HorizontalLineLabel(
                show: true,
                // labelResolver: (a) => 'Zero Net Flow',
                alignment: Alignment.topRight,
                style: AppTextStyles.body4.copyWith(
                  color: context.incomeForeground,
                ),
              ),
            ),
          ],
        ),

        // Tooltip (shows net amount and day)
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (group) => context.secondaryBackgroundSolid,
            tooltipBorder: BorderSide(color: context.purpleBorderLighter),
            tooltipBorderRadius: BorderRadius.circular(AppRadius.radius8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final isPositive = flSpot.y >= 0;
                final color = isPositive
                    ? context.incomeText
                    : context.expenseText;

                return LineTooltipItem(
                  flSpot.y.toShortPriceFormat(), // Show + or - sign
                  TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: '\nDay ${flSpot.x.toInt()}',
                      style: AppTextStyles.body3,
                    ),
                  ],
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),

        // Grid Data
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: maxY / 3, // Create grid for context
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withAlpha(50),
            strokeWidth: 1,
          ),
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withAlpha(50),
            strokeWidth: 1,
          ),
        ),

        // Axis Titles
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 5, // Show titles every 5 days
              getTitlesWidget: (value, meta) {
                if (value == 1 || value % 5 == 0 || value == data.last.day) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${value.toInt()}', // Just the day number
                      style: AppTextStyles.body4.bold,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 3,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  value.toShortPriceFormat(),
                  style: AppTextStyles.body4,
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),

        // Line Data
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.tertiary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isToday = spot.x == currentDay;
                // Highlight the current day's spot
                return FlDotCirclePainter(
                  radius: isToday ? 6 : 3,
                  color: isToday ? Colors.white : AppColors.tertiary,
                  strokeWidth: isToday ? 3 : 1,
                  strokeColor: isToday
                      ? AppColors.tertiary
                      : Colors.transparent,
                );
              },
            ),
            // Shade the area below the line for visual impact
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  context.incomeForeground.withAlpha(
                    35,
                  ), // Above 0 is income/savings
                  context.incomeForeground.withAlpha(
                    35,
                  ), // Below 0 is expense/deficit
                ],
                // We use stops to ensure the gradient visually changes correctly at y=0,
                // but for simplicity in fl_chart, we use a single color for the area fill
                // or rely on the `spots` data defining the positive/negative space
              ),
              color: AppColors.tertiary.withAlpha(
                20,
              ), // Simple fill for clean look
            ),
          ),
        ],
      ),
    );
  }
}
