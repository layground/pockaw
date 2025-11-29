part of '../screens/basic_monthly_report_screen.dart';

class SpendingPieChart extends ConsumerWidget {
  final List<CategoryChartData> expenseData;
  final double totalExpenses;
  final bool isLoading;

  const SpendingPieChart({
    super.key,
    required this.expenseData,
    required this.totalExpenses,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, ref) {
    final touchedIndex = ref.watch(pieChartTouchIndexProvider);
    final touchedIndexState = ref.read(pieChartTouchIndexProvider.notifier);

    if (isLoading) {
      return LoadingIndicator();
    }

    if (expenseData.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(child: Text('No expenses to display')),
      );
    }

    List<PieChartSectionData> showingSections() {
      return List.generate(expenseData.length, (i) {
        final isTouched = i == touchedIndex;
        final data = expenseData[i];

        // Highlight effect size
        final radius = isTouched ? 60.0 : 50.0;
        final fontSize = isTouched ? 14.0 : 12.0;
        final widgetSize = isTouched ? 55.0 : 40.0;

        return PieChartSectionData(
          color: data.color,
          value: data.amount,
          title: '', // Hide internal title to use badges or cleaner look
          radius: radius,
          // Show value badge outside or inside based on design preference
          badgeWidget: _Badge(
            data.amount,
            size: widgetSize,
            borderColor: data.color,
          ),
          badgePositionPercentageOffset: 1.2, // Positions labels outside
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        );
      });
    }

    Widget buildLegend() {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: expenseData.map((data) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: data.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                data.category,
                style: AppTextStyles.body4,
              ),
            ],
          );
        }).toList(),
      );
    }

    return ChartContainer(
      title: 'Spending by Category',
      subtitle: 'Current Month Breakdown',
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
      chart: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndexState.set(-1);
                          return;
                        }
                        touchedIndexState.set(
                          pieTouchResponse.touchedSection!.touchedSectionIndex,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: showingSections(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Spent',
                        style: AppTextStyles.body3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalExpenses.toShortPriceFormat(),
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildLegend(),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final double amount;
  final double size;
  final Color borderColor;

  const _Badge(
    this.amount, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // fl_chart animationDuration
      width: size + 20, // Make it wide enough for text
      height: size / 1.5,
      decoration: BoxDecoration(
        color: context.secondaryBackgroundSolid,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            offset: const Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: Text(
          amount.toShortPriceFormat(),
          style: AppTextStyles.body4,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
