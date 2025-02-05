part of '../screens/dashboard_screen.dart';

class RecentTransactionList extends StatelessWidget {
  const RecentTransactionList({super.key});

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
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 100),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) => const TransactionTile(),
            separatorBuilder: (context, index) =>
                const Gap(AppSpacing.spacing16),
          )
        ],
      ),
    );
  }
}
