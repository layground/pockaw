import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/transaction/application/providers/transaction_providers.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';

class BudgetTopTransactions extends ConsumerWidget {
  const BudgetTopTransactions({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final List<Transaction> allTransactions = ref.watch(
      transactionListProvider,
    );

    // For "top transactions", you might want to sort by amount (e.g., largest expenses)
    // or by date (most recent). For this example, let's show the 5 most recent.
    // You can change this logic based on your specific needs for "top transactions".
    final List<Transaction> sortedTransactions = List.from(allTransactions)
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first

    // If you wanted largest expenses:
    // ..sort((a, b) => b.amount.compareTo(a.amount));
    // final List<Transaction> topExpenseTransactions = sortedTransactions.where((t) => t.transactionType == TransactionType.expense).take(5).toList();

    final List<Transaction> displayTransactions = sortedTransactions
        .take(5)
        .toList();

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 100),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayTransactions.length,
      itemBuilder: (context, index) =>
          TransactionTile(transaction: displayTransactions[index]),
      separatorBuilder: (context, index) => const Gap(AppSpacing.spacing16),
    );
  }
}
