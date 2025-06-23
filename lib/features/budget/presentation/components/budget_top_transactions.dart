import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';

class BudgetTopTransactions extends StatelessWidget {
  const BudgetTopTransactions({super.key, required this.transactions});
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 100),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => TransactionTile(
        transaction: transactions[index],
        showDate: false,
      ),
      separatorBuilder: (context, index) => const Gap(AppSpacing.spacing16),
    );
  }
}
