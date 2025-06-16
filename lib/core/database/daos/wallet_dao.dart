import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(super.db);

  Future<WalletModel> _mapToWalletModel(Wallet walletData) async {
    return walletData.toModel();
  }

  Stream<List<WalletModel>> watchAllWallets() {
    Log.d('🔍 Subscribing to watchAllWallets()');
    return select(wallets).watch().asyncMap((walletList) async {
      Log.d('📋 watchAllWallets emitted ${walletList.length} rows');
      return walletList.map((e) => e.toModel()).toList();
    });
  }

  Stream<WalletModel?> watchWalletById(int id) {
    Log.d('🔍 Subscribing to watchWalletById($id)');
    return (select(wallets)..where((w) => w.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((walletData) async {
          if (walletData == null) return null;
          return await _mapToWalletModel(walletData);
        });
  }

  Future<int> addWallet(WalletModel walletModel) async {
    Log.d('Saving New Wallet: ${walletModel.toJson()}');
    final companion = walletModel.toCompanion(isInsert: true);
    return await into(wallets).insert(companion);
  }

  Future<bool> updateWallet(WalletModel walletModel) async {
    Log.d('Updating Wallet: ${walletModel.toJson()}');
    if (walletModel.id == null) {
      Log.e('Wallet ID is null, cannot update.');
      return false;
    }
    final companion = walletModel.toCompanion();
    return await update(wallets).replace(companion);
  }

  Future<int> deleteWallet(WidgetRef ref, int id) {
    // final db = ref.read(databaseProvider);

    /// Delete everything linked to this wallet

    Log.d('Deleting Wallet with ID: $id');
    return (delete(wallets)..where((w) => w.id.equals(id))).go();
  }

  Future<void> upsertWallet(WalletModel walletModel) async {
    Log.d('Upserting Wallet: ${walletModel.toJson()}');
    // For upsert, if ID is null, it's an insert.
    // If ID is present, it's an update on conflict.
    // The toCompanion handles Value.absent() for ID on insert.
    final companion = WalletsCompanion(
      id: walletModel.id == null
          ? const Value.absent()
          : Value(walletModel.id!),
      name: Value(walletModel.name),
      balance: Value(walletModel.balance),
      currency: Value(walletModel.currency),
      iconName: Value(walletModel.iconName),
      colorHex: Value(walletModel.colorHex),
      createdAt: walletModel.id == null
          ? Value(DateTime.now())
          : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await into(wallets).insertOnConflictUpdate(companion);
  }
}
