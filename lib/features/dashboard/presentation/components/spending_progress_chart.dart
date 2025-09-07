part of '../screens/dashboard_screen.dart';

class SpendingProgressChart extends ConsumerWidget {
  const SpendingProgressChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsyncValue = ref.watch(transactionListProvider);

    // Define a list of colors for categories
    final List<Color> categoryColors = [
      const Color(0xFF93DBF3), // Light Blue
      const Color(0xFFE27DE5), // Pink/Purple
      const Color(0xFFA0EBA1), // Light Green
      const Color(0xFFEBC58F), // Light Orange/Yellow
      const Color(0xFFADD8E6), // Another Light Blue
      const Color(0xFFF08080), // Light Coral
    ];

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

        // If there are more than 4 categories, group the rest into "Others"
        // For simplicity, this example just takes the top 4.
        // A more complex implementation could sum the rest into an "Others" category.

        return Column(
          children: [
            _buildHeader(context),
            const Gap(AppSpacing.spacing8),
            if (topCategories.isNotEmpty)
              Row(
                children: topCategories.map((entry) {
                  // final categoryName = entry.key;
                  final categoryTotal = entry.value;
                  final percentage = totalMonthSpending > 0
                      ? categoryTotal / totalMonthSpending
                      : 0.0;
                  final colorIndex =
                      topCategories.indexOf(entry) % categoryColors.length;
                  final color = categoryColors[colorIndex];

                  // Determine radius for first and last items
                  BorderRadius? radius;
                  if (topCategories.first == entry) {
                    radius = const BorderRadius.horizontal(
                      left: Radius.circular(AppRadius.radiusFull),
                    );
                  }
                  if (topCategories.last == entry && topCategories.length > 1) {
                    // Only apply right radius if it's also the last element and not the only element
                    radius =
                        radius?.copyWith(
                          topRight: const Radius.circular(AppRadius.radiusFull),
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
                  );
                }).toList(),
              )
            else
              Container(), // Empty container if no categories to show in progress bar
            const Gap(AppSpacing.spacing8),
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
                  final colorIndex =
                      topCategories.indexOf(entry) % categoryColors.length;
                  final color = categoryColors[colorIndex];
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
          style: AppTextStyles.body4.copyWith(
            fontVariations: [AppFontWeights.medium],
          ),
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
