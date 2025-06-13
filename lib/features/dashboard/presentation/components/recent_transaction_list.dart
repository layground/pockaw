part of '../screens/dashboard_screen.dart';

class RecentTransactionList extends ConsumerWidget {
  // Changed to ConsumerWidget
  const RecentTransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef
    // Watch the provider to get the list of transactions
    final List<Transaction> allTransactions = ref.watch(
      transactionListProvider,
    );

    // Sort transactions by date to get the most recent ones, then take the top 5 (or fewer if not enough)
    final List<Transaction> recentTransactions = List.from(allTransactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    final List<Transaction> displayTransactions = recentTransactions
        .take(5)
        .toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Transactions', style: AppTextStyles.heading6),
          const Gap(AppSpacing.spacing16),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 100),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayTransactions
                .length, // Use the length of our filtered list
            itemBuilder: (context, index) {
              final transaction = displayTransactions[index];
              return TransactionTile(
                transaction: transaction,
              ); // Pass the actual transaction
            },
            separatorBuilder: (context, index) =>
                const Gap(AppSpacing.spacing16),
          ),
        ],
      ),
    );
  }
}
