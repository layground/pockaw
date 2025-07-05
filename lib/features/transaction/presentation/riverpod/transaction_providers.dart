import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/features/transaction/data/model/transaction_filter_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart'; // Import activeWalletProvider

/// Emits a new list of transactions for the currently active wallet.
final transactionListProvider =
    StreamProvider.autoDispose<List<TransactionModel>>((ref) {
      final db = ref.watch(databaseProvider);
      final activeWalletAsync = ref.watch(activeWalletProvider);
      final filter = ref.watch(transactionFilterProvider);

      return activeWalletAsync.when(
        data: (activeWallet) {
          if (activeWallet == null || activeWallet.id == null) {
            return Stream.value([]);
          }
          // Use the new filtered DAO method
          return db.transactionDao.watchFilteredTransactionsWithDetails(
            walletId: activeWallet.id!,
            filter: filter,
          );
        },
        loading: () => Stream.value([]),
        error: (e, s) => Stream.error(e, s),
      );
    });

final transactionDetailsProvider = StreamProvider.autoDispose.family<TransactionModel?, int>((
  ref,
  id,
) {
  final db = ref.watch(databaseProvider);
  // This provider fetches a single transaction. It might not need to be wallet-specific,
  // as you're fetching by a unique transaction ID.
  // The DAO's watchTransactionByID returns a Transaction table object.
  // We need a DAO method that returns TransactionModel with details for a specific ID.
  // Let's assume TransactionDao will have watchTransactionDetailsById(id) -> Stream<TransactionModel?>
  // For now, this will likely break or need adjustment in TransactionDao.
  // The current watchTransactionByID in DAO returns `Stream<Transaction>` (table object).
  // It should ideally return `Stream<TransactionModel>` by joining with category/wallet.
  //
  // A quick fix for now might be to use a more general fetch if the DAO isn't updated:
  // return db.transactionDao.watchAllTransactionsWithDetails().map((list) => list.firstWhere((tx) => tx.id == id, orElse: () => null));
  // This is inefficient. The DAO should provide a direct method.
  //
  // Assuming TransactionDao is updated to have:
  // Stream<TransactionModel?> watchTransactionDetailsById(int transactionId)
  // For now, this provider will be left as is, but it highlights a need for DAO improvement.
  // The current `transactionDetailsProvider` in the context uses `watchTransactionByID` which returns `Transaction` (table object)
  // and then tries to map it. This mapping needs category and wallet.
  //
  // The most straightforward way is to make `transactionDetailsProvider` use `watchAllTransactionsWithDetails`
  // and filter, or add a specific DAO method.
  // Let's assume `watchAllTransactionsWithDetails` is efficient enough for now for finding one item.
  return db.transactionDao.watchAllTransactionsWithDetails().map(
    (transactions) => transactions.firstWhere((tx) => tx.id == id),
  );
});

final transactionFilterProvider = StateProvider<TransactionFilter?>(
  (ref) => null,
);
