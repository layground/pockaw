part of '../screens/dashboard_screen.dart';

class RecentTransactionList extends StatelessWidget {
  const RecentTransactionList({super.key, required this.transactions});
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: AppTextStyles.heading6,
          ),
          const Gap(AppSpacing.spacing16),
          if (transactions.isEmpty)
            const Center(child: Text('No recent transactions'))
          else
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 100),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) => TransactionTile(
                transaction: transactions[index],
                showDate: false,
              ),
              separatorBuilder: (context, index) =>
                  const Gap(AppSpacing.spacing16),
            )
        ],
      ),
    );
  }
}
