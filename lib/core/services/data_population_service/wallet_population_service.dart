import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart'; // Assuming defaultWallets is here

class WalletPopulationService {
  static Future<void> populate(AppDatabase db) async {
    Log.i('Populating default wallets...', label: 'wallet');
    for (final walletModel in defaultWallets) {
      try {
        await db.walletDao.addWallet(walletModel);
        Log.d(
          'Successfully added default wallet: ${walletModel.name}',
          label: 'wallet',
        );
      } catch (e) {
        Log.e(
          'Failed to add default wallet ${walletModel.name}: $e',
          label: 'wallet',
        );
      }
    }

    Log.i(
      'Default wallets populated successfully: (${defaultWallets.length})',
      label: 'wallet',
    );
  }
}
