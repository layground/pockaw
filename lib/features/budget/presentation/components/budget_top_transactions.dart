import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/components/transaction_tile.dart';

class BudgetTopTransactions extends ConsumerWidget {
  final BudgetModel budget;
  const BudgetTopTransactions({super.key, required this.budget});

  @override
  Widget build(BuildContext context, ref) {
    final asyncTransactions = ref.watch(transactionsForBudgetProvider(budget));

    return asyncTransactions.when(
      data: (allTransactions) {
        if (allTransactions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing20),
            child: Center(
              child: Text(
                'No transactions to display.',
                style: AppTextStyles.body3,
              ),
            ),
          );
        }
        // Transactions are already filtered by budget criteria. Sort by date.
        final List<TransactionModel> sortedTransactions = List.from(
          allTransactions,
        )..sort((a, b) => b.date.compareTo(a.date)); // Most recent first

        final List<TransactionModel> displayTransactions = sortedTransactions
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Error: $error\n$stackTrace')),
    );
  }
}
