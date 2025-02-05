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
            backgroundColor: AppColors.primary50,
            titleColor: AppColors.neutral900,
            borderColor: AppColors.primaryAlpha25,
            amountColor: AppColors.primary900,
            statsBackgroundColor: AppColors.primaryAlpha10,
            statsForegroundColor: AppColors.neutral800,
            statsIconColor: AppColors.primary600,
          ),
        ),
        Gap(AppSpacing.spacing12),
        Expanded(
          child: TransactionCard(
            title: 'Expense',
            amount: 763120,
            amountLastMonth: 335900,
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
