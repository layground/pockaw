part of '../screens/dashboard_screen.dart';

class CashFlowCards extends StatelessWidget {
  const CashFlowCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TransactionCard(
            title: 'Income',
            amount: 589234,
            amountLastMonth: 123000,
            titleColor: AppColors.secondary300,
            backgroundColor: AppColors.secondary,
            amountColor: AppColors.secondary100,
            statsBackgroundColor: AppColors.primaryAlpha25,
            statsForegroundColor: AppColors.secondary100,
            statsIconColor: AppColors.green100,
          ),
        ),
        Gap(AppSpacing.spacing12),
        Expanded(
          child: TransactionCard(
            title: 'Expense',
            amount: 763120,
            amountLastMonth: 335900,
            backgroundColor: AppColors.tertiary900,
            titleColor: AppColors.primary600,
            amountColor: AppColors.secondary,
            statsBackgroundColor: AppColors.primaryAlpha25,
            statsForegroundColor: AppColors.secondary950,
            statsIconColor: AppColors.red200,
          ),
        ),
      ],
    );
  }
}
