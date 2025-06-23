import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_actions_provider.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transactions_list_provider.dart';
import 'package:drift/drift.dart' hide Column;

class TransactionTestScreen extends ConsumerWidget {
  const TransactionTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsListProvider);

    return CustomScaffold(
      context: context,
      title: 'Transaction Test',
      body: Column(
        children: [
          // Test button to add a transaction
          Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing20),
            child: ElevatedButton(
              onPressed: () async {
                final actions = ref.read(transactionActionsProvider);
                await actions.add(
                  TransactionsCompanion(
                    title: Value('Test Transaction'),
                    amount: Value(100.0),
                    description: Value('This is a test transaction'),
                    date: Value(DateTime.now()),
                    categoryId: Value(1),
                    transactionType: Value('expense'),
                    accountId: Value(1),
                  ),
                );
              },
              child: const Text('Add Test Transaction'),
            ),
          ),
          // Display transactions
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(child: Text('No transactions yet'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.spacing20),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      child: ListTile(
                        title: Text(transaction.title),
                        subtitle: Text(transaction.description ?? ''),
                        trailing: Text('\$${transaction.amount}'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
