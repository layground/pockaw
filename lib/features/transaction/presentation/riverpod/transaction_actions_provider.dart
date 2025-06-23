import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/core/db/database_provider.dart';

/// A simple grouping of your DB write methods
class TransactionActions {
  final Future<int> Function(TransactionsCompanion) add;
  final Future<bool> Function(Transaction) update;
  final Future<int> Function(int) delete;

  TransactionActions({
    required this.add,
    required this.update,
    required this.delete,
  });
}

/// Expose your CRUD methods via Riverpod
final transactionActionsProvider = Provider<TransactionActions>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionActions(
    add: db.addTransaction,
    update: db.updateTransaction,
    delete: db.deleteTransaction,
  );
});
