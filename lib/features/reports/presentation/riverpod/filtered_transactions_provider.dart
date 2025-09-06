import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_providers.dart';

final monthlyTransactionsProvider =
    Provider.family<AsyncValue<List<TransactionModel>>, DateTime>((ref, date) {
      final transactionsAsync = ref.watch(transactionListProvider);

      return transactionsAsync.when(
        data: (transactions) {
          // Filter transactions for the given month
          return AsyncValue.data(
            transactions.where((t) {
              return t.date.year == date.year && t.date.month == date.month;
            }).toList(),
          );
        },
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      );
    });
