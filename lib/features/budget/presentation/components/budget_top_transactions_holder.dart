import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/budget/presentation/components/budget_top_transactions.dart';

class BudgetTopTransactionsHolder extends StatelessWidget {
  final BudgetModel budget;
  const BudgetTopTransactionsHolder({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Transactions', style: AppTextStyles.body3),
          Gap(AppSpacing.spacing12),
          BudgetTopTransactions(budget: budget),
        ],
      ),
    );
  }
}
