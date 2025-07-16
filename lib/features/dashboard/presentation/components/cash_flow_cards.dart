part of '../screens/dashboard_screen.dart';

class CashFlowCards extends ConsumerWidget {
  const CashFlowCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsyncValue = ref.watch(transactionListProvider);

    return transactionsAsyncValue.when(
      data: (transactions) {
        final now = DateTime.now();
        final currentMonth = now.month;
        final currentYear = now.year;

        final lastMonthDate = DateTime(currentYear, currentMonth - 1);
        final lastMonth = lastMonthDate.month;
        final lastMonthYear = lastMonthDate.year;

        // Calculate current month's income and expenses
        double currentMonthIncome = 0;
        double currentMonthExpense = 0;
        for (var t in transactions) {
          if (t.date.year == currentYear && t.date.month == currentMonth) {
            if (t.transactionType == TransactionType.income) {
              currentMonthIncome += t.amount;
            } else if (t.transactionType == TransactionType.expense) {
              currentMonthExpense += t.amount;
            }
          }
        }

        // Calculate last month's income and expenses
        double lastMonthIncome = 0;
        double lastMonthExpense = 0;
        for (var t in transactions) {
          if (t.date.year == lastMonthYear && t.date.month == lastMonth) {
            if (t.transactionType == TransactionType.income) {
              lastMonthIncome += t.amount;
            } else if (t.transactionType == TransactionType.expense) {
              lastMonthExpense += t.amount;
            }
          }
        }

        final incomePercentDifference = currentMonthIncome
            .calculatePercentDifference(lastMonthIncome);
        final expensePercentDifference = currentMonthExpense
            .calculatePercentDifference(lastMonthExpense);

        return Row(
          children: [
            Expanded(
              child: TransactionCard(
                title: 'Income • ${DateTime.now().toMonthName()}',
                amount: currentMonthIncome,
                amountLastMonth: lastMonthIncome,
                percentDifference: incomePercentDifference,
                backgroundColor: context.incomeBackground(context.themeMode),
                titleColor: context.incomeForeground(context.themeMode),
                borderColor: context.incomeLine(context.themeMode),
                amountColor: context.incomeText(context.themeMode),
                statsBackgroundColor: context.incomeBackground(
                  context.themeMode,
                ),
                statsForegroundColor: context.incomeForeground(
                  context.themeMode,
                ),
                statsIconColor: context.incomeText(context.themeMode),
              ),
            ),
            const Gap(AppSpacing.spacing12),
            Expanded(
              child: TransactionCard(
                title: 'Expense • ${DateTime.now().toMonthName()}',
                amount: currentMonthExpense,
                amountLastMonth: lastMonthExpense,
                percentDifference: expensePercentDifference,
                backgroundColor: context.expenseBackground(context.themeMode),
                titleColor: context.expenseForeground(context.themeMode),
                borderColor: context.expenseLine(context.themeMode),
                amountColor: context.expenseText(context.themeMode),
                statsBackgroundColor: context.expenseStatsBackground(
                  context.themeMode,
                ),
                statsForegroundColor: context.expenseForeground(
                  context.themeMode,
                ),
                statsIconColor: context.expenseText(context.themeMode),
              ),
            ),
          ],
        );
      },
      loading: () => const Row(
        children: [
          Expanded(child: ShimmerTransactionCardPlaceholder()),
          Gap(AppSpacing.spacing12),
          Expanded(child: ShimmerTransactionCardPlaceholder()),
        ],
      ),
      error: (error, stack) => Row(
        children: [
          Expanded(child: Center(child: Text('Error loading income data'))),
          const Gap(AppSpacing.spacing12),
          Expanded(child: Center(child: Text('Error loading expense data'))),
        ],
      ),
    );
  }
}

// Optional: A placeholder for loading state to improve UX
class ShimmerTransactionCardPlaceholder extends StatelessWidget {
  const ShimmerTransactionCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // You can use a shimmer effect package or a simple container
    return Container(
      height: 150, // Adjust to match TransactionCard's approximate height
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: context.purpleBackground(context.themeMode),
        borderRadius: BorderRadius.circular(AppRadius.radius16),
      ),
      child: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
