import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
// import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart'; // No longer needed for hardcoded list

/// Provider to stream all wallets from the database.
final allWalletsStreamProvider = StreamProvider.autoDispose<List<WalletModel>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return db.walletDao.watchAllWallets();
});

/// Use a Notifier to hold simple mutable boolean state (replaces StateProvider)
class WalletAmountVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true; // default visible
  }

  void setVisible(bool visible) => state = visible;
  void toggle() => state = !state;
}

final walletAmountVisibilityProvider =
    NotifierProvider<WalletAmountVisibilityNotifier, bool>(
      WalletAmountVisibilityNotifier.new,
    );

/// StateNotifier for managing the active wallet.
class ActiveWalletNotifier extends AsyncNotifier<WalletModel?> {
  @override
  Future<WalletModel?> build() async {
    // called once when the notifier is first created
    try {
      final db = ref.read(databaseProvider);
      final wallets = await db.walletDao.watchAllWallets().first;
      if (wallets.isNotEmpty) return wallets.first;
      return null;
    } catch (e) {
      // Re-throw to let Riverpod handle the error state
      rethrow;
    }
  }

  void setActiveWallet(WalletModel? wallet) {
    state = AsyncValue.data(wallet);
  }

  Future<void> setActiveWalletByID(int walletID) async {
    final db = ref.read(databaseProvider);
    final wallets = await db.walletDao.watchAllWallets().first;
    if (wallets.isNotEmpty) {
      state = AsyncValue.data(
        wallets.firstWhere((wallet) => wallet.id == walletID),
      );
    }
  }

  void updateActiveWallet(WalletModel? newWalletData) {
    final currentActiveWallet = state.asData?.value;
    final currentActiveWalletId = currentActiveWallet?.id;

    if (newWalletData != null && newWalletData.id == currentActiveWalletId) {
      Log.d(
        'Updating active wallet ID ${newWalletData.id} with new data: ${newWalletData.toJson()}',
        label: 'ActiveWalletNotifier',
      );
      state = AsyncValue.data(newWalletData);
    } else if (newWalletData != null && currentActiveWalletId == null) {
      Log.d(
        'Setting active wallet (was null) to ID ${newWalletData.id} via updateActiveWallet: ${newWalletData.toJson()}',
        label: 'ActiveWalletNotifier',
      );
      state = AsyncValue.data(newWalletData);
    } else if (newWalletData == null && currentActiveWalletId != null) {
      Log.d(
        'Clearing active wallet (was ID $currentActiveWalletId) via updateActiveWallet.',
        label: 'ActiveWalletNotifier',
      );
      state = const AsyncValue.data(null);
    }
  }

  Future<void> refreshActiveWallet() async {
    final currentWalletId = state.asData?.value?.id;
    if (currentWalletId != null) {
      try {
        final db = ref.read(databaseProvider);
        final refreshedWallet = await db.walletDao
            .watchWalletById(currentWalletId)
            .first;
        state = AsyncValue.data(refreshedWallet);
      } catch (e, s) {
        state = AsyncValue.error(e, s);
      }
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final activeWalletProvider =
    AsyncNotifierProvider<ActiveWalletNotifier, WalletModel?>(
      ActiveWalletNotifier.new,
    );
