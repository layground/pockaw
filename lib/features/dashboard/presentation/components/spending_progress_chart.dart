part of '../screens/dashboard_screen.dart';

class SpendingProgressChart extends ConsumerWidget {
  const SpendingProgressChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Random random = Random(30);
    final transactionsAsyncValue = ref.watch(transactionListProvider);

    return transactionsAsyncValue.when(
      data: (transactions) {
        final now = DateTime.now();
        final currentMonthExpenses = transactions.where((t) {
          return t.date.year == now.year &&
              t.date.month == now.month &&
              t.transactionType == TransactionType.expense;
        }).toList();

        if (currentMonthExpenses.isEmpty) {
          return Column(
            children: [
              _buildHeader(context),
              const Gap(AppSpacing.spacing8),
              CustomProgressIndicator(
                value: 0,
                color: context.placeholderBackground,
                radius: BorderRadius.circular(AppRadius.radiusFull),
              ),
            ],
          );
        }

        // Group expenses by category and sum amounts
        final Map<String, double> categorySpending = {};
        for (var expense in currentMonthExpenses) {
          final categoryName =
              expense.category.title; // Assuming title is the display name
          categorySpending[categoryName] =
              (categorySpending[categoryName] ?? 0) + expense.amount;
        }

        final totalMonthSpending = currentMonthExpenses.fold(
          0.0,
          (sum, t) => sum + t.amount,
        );

        // Sort categories by spending (descending) and take top N (e.g., 4)
        final sortedCategories = categorySpending.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final topCategories = sortedCategories.take(4).toList();

        // Use a persistent map to store colors for consistent display across reloads
        final Map<String, Color> colorMap = {};
        for (var entry in sortedCategories) {
          if (!colorMap.containsKey(entry.key)) {
            // Generate a color only if it doesn't exist yet
            colorMap[entry.key] = ColorGenerator.generatePleasingRandomColor(
              random,
            );
          }
        }

        // If there are more than 4 categories, group the rest into "Others"
        // For simplicity, this example just takes the top 4.
        // A more complex implementation could sum the rest into an "Others" category.

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            color: context.purpleBackground,
            borderRadius: BorderRadius.circular(AppRadius.radius16),
            border: Border.all(color: context.secondaryBorderLighter),
          ),
          child: Column(
            spacing: AppSpacing.spacing20,
            children: [
              _buildHeader(context),
              if (topCategories.isNotEmpty)
                Row(
                  children: topCategories.map((entry) {
                    // final categoryName = entry.key;
                    final categoryTotal = entry.value;
                    final percentage = totalMonthSpending > 0
                        ? categoryTotal / totalMonthSpending
                        : 0.0;
                    final color = colorMap[entry.key]!;

                    // Determine radius for first and last items
                    BorderRadius? radius;
                    if (topCategories.first == entry) {
                      radius = const BorderRadius.horizontal(
                        left: Radius.circular(AppRadius.radiusFull),
                      );
                    }
                    if (topCategories.last == entry &&
                        topCategories.length > 1) {
                      // Only apply right radius if it's also the last element and not the only element
                      radius =
                          radius?.copyWith(
                            topRight: const Radius.circular(
                              AppRadius.radiusFull,
                            ),
                            bottomRight: const Radius.circular(
                              AppRadius.radiusFull,
                            ),
                          ) ??
                          const BorderRadius.horizontal(
                            right: Radius.circular(AppRadius.radiusFull),
                          );
                    } else if (topCategories.last == entry &&
                        topCategories.length == 1) {
                      radius = BorderRadius.circular(
                        AppRadius.radiusFull,
                      ); // Full radius if only one item
                    }

                    return CustomProgressIndicator(
                      value: percentage,
                      color: color,
                      radius: radius,
                      height: 14,
                    );
                  }).toList(),
                )
              else
                Container(),
              if (topCategories.isNotEmpty)
                Wrap(
                  spacing:
                      AppSpacing.spacing8, // Horizontal space between legends
                  runSpacing: AppSpacing
                      .spacing4, // Vertical space between lines of legends
                  alignment: WrapAlignment
                      .start, // Or WrapAlignment.center if you prefer
                  children: topCategories.map((entry) {
                    final categoryName = entry.key;
                    final color = colorMap[entry.key]!;
                    // No longer need Flexible or extra Padding here as Wrap handles spacing
                    return CustomProgressIndicatorLegend(
                      label: categoryName,
                      color: color,
                    );
                  }).toList(),
                )
              else
                Container(), // Empty container if no legends
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stack) =>
          Center(child: Text('Error loading spending data: $error')),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My spending this month',
          style: AppTextStyles.body3,
        ),
        InkWell(
          onTap: () {
            context.push(Routes.basicMonthlyReports, extra: DateTime.now());
          },
          child: Text(
            'View report',
            style: AppTextStyles.body5.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
