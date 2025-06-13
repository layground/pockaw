import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/data/repositories/local/transaction_repo.dart'; // Assuming this is the correct path

/// Provider to expose the list of transactions.
///
/// In a real application, this might fetch data from an API or local database,
/// and you might use a StateNotifierProvider or FutureProvider.
/// For this static list, a simple Provider is sufficient.
final transactionListProvider = Provider<List<Transaction>>((ref) {
  // Directly return the static list from your repository
  return transactions;
});

// You could also add providers for specific filtered lists if needed, for example:
// final incomeTransactionsProvider = Provider<List<Transaction>>((ref) {
//   final allTransactions = ref.watch(transactionListProvider);
//   return allTransactions.where((t) => t.transactionType == TransactionType.income).toList();
// });

// final expenseTransactionsProvider = Provider<List<Transaction>>((ref) {
//   final allTransactions = ref.watch(transactionListProvider);
//   return allTransactions.where((t) => t.transactionType == TransactionType.expense).toList();
// });
