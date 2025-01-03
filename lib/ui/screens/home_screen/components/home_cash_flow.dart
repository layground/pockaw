import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_transaction_card.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';

class HomeCashFlow extends StatelessWidget {
  const HomeCashFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: HomeTransactionCard(
            title: 'Income',
            amount: 589234,
            amountLastMonth: 123000,
            titleColor: AppColors.secondary300,
            backgroundColor: AppColors.secondary,
            amountColor: AppColors.secondary100,
            statsBackgroundColor: AppColors.primaryAlpha20,
            statsForegroundColor: AppColors.secondary100,
            statsIconColor: AppColors.green100,
          ),
        ),
        Gap(AppSpacing.spacing12),
        Expanded(
          child: HomeTransactionCard(
            title: 'Expense',
            amount: 763120,
            amountLastMonth: 335900,
            backgroundColor: AppColors.tertiary900,
            titleColor: AppColors.primary600,
            amountColor: AppColors.secondary,
            statsBackgroundColor: AppColors.primaryAlpha20,
            statsForegroundColor: AppColors.secondary1000,
            statsIconColor: AppColors.red200,
          ),
        ),
      ],
    );
  }
}
