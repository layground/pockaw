part of '../screens/dashboard_screen.dart';

class CashFlowCards extends StatelessWidget {
  final double income;
  final double expense;
  const CashFlowCards({super.key, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TransactionCard(
            title: 'Income',
            amount: income,
            amountLastMonth: 0,
            backgroundColor: AppColors.primary50,
            titleColor: AppColors.neutral900,
            borderColor: AppColors.primaryAlpha25,
            amountColor: AppColors.primary900,
            statsBackgroundColor: AppColors.primaryAlpha10,
            statsForegroundColor: AppColors.neutral800,
            statsIconColor: AppColors.primary600,
          ),
        ),
        const Gap(AppSpacing.spacing12),
        Expanded(
          child: TransactionCard(
            title: 'Expense',
            amount: expense,
            amountLastMonth: 0,
            backgroundColor: AppColors.red50,
            borderColor: AppColors.redAlpha10,
            titleColor: AppColors.neutral900,
            amountColor: AppColors.red900,
            statsBackgroundColor: AppColors.redAlpha10,
            statsForegroundColor: AppColors.red800,
            statsIconColor: AppColors.red800,
          ),
        ),
      ],
    );
  }
}
