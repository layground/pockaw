import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
// import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart'; // No longer needed for hardcoded list

/// Provider to stream all wallets from the database.
final allWalletsStreamProvider = StreamProvider.autoDispose<List<WalletModel>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return db.walletDao.watchAllWallets();
});

/// StateNotifier for managing the active wallet.
class ActiveWalletNotifier extends StateNotifier<AsyncValue<WalletModel?>> {
  final Ref _ref;

  ActiveWalletNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initializeActiveWallet();
  }

  // Renamed to fetchAndSetInitialWallet for clarity
  Future<void> _initializeActiveWallet() async {
    try {
      final db = _ref.read(databaseProvider);
      // Attempt to get the first wallet from the database
      // Using watchAllWallets().first might be problematic if the stream doesn't emit quickly during init.
      final wallets = await db.walletDao.watchAllWallets().first;
      if (wallets.isNotEmpty) {
        state = AsyncValue.data(wallets.first);
      } else {
        // This case should ideally not happen if default wallets are populated.
        // If it does, it means no wallets exist.
        state = const AsyncValue.data(null); // No active wallet
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void setActiveWallet(WalletModel? wallet) {
    state = AsyncValue.data(wallet);
  }

  /// Refreshes the data for the currently active wallet from the database.
  /// Useful if the wallet data might have changed externally or by other operations.
  Future<void> refreshActiveWallet() async {
    final currentWalletId = state.valueOrNull?.id;
    if (currentWalletId != null) {
      try {
        final db = _ref.read(databaseProvider);
        final refreshedWallet = await db.walletDao
            .watchWalletById(currentWalletId)
            .first;
        state = AsyncValue.data(refreshedWallet);
      } catch (e, s) {
        // Keep the old state but log error, or set to error state
        state = AsyncValue.error(e, s);
      }
    }
  }
}

/// Provider for the ActiveWalletNotifier, managing the currently selected wallet.
final activeWalletProvider =
    StateNotifierProvider<ActiveWalletNotifier, AsyncValue<WalletModel?>>((
      ref,
    ) {
      return ActiveWalletNotifier(ref);
    });
