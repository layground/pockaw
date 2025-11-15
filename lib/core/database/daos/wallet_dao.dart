import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(super.db);

  WalletModel _mapToWalletModel(Wallet walletData) {
    return walletData.toModel();
  }

  Stream<List<WalletModel>> watchAllWallets() {
    Log.d('Subscribing to watchAllWallets()', label: 'wallet');
    return select(wallets).watch().asyncMap((walletList) async {
      Log.d(
        'watchAllWallets emitted ${walletList.length} rows',
        label: 'wallet',
      );
      return walletList.map((e) => e.toModel()).toList();
    });
  }

  Stream<WalletModel?> watchWalletById(int id) {
    Log.d('Subscribing to watchWalletById($id)', label: 'wallet');
    return (select(wallets)..where((w) => w.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((walletData) async {
          if (walletData == null) return null;
          return _mapToWalletModel(walletData);
        });
  }

  /// Fetches all wallets.
  Future<List<Wallet>> getAllWallets() {
    return select(wallets).get();
  }

  Future<Wallet?> getWalletById(int id) {
    return (select(wallets)..where((w) => w.id.equals(id))).getSingleOrNull();
  }

  Future<Wallet?> getWalletByUserId(int userId) {
    return (select(
      wallets,
    )..where((w) => w.id.equals(userId))).getSingleOrNull();
  }

  Future<List<Wallet>> getWalletsByIds(List<int> ids) {
    if (ids.isEmpty) return Future.value([]);
    return (select(wallets)..where((w) => w.id.isIn(ids))).get();
  }

  Future<int> addWallet(WalletModel walletModel) async {
    Log.d('Saving New Wallet: ${walletModel.toJson()}', label: 'wallet');
    final companion = walletModel.toCompanion(isInsert: true);
    return await into(wallets).insert(companion);
  }

  Future<bool> updateWallet(WalletModel walletModel) async {
    Log.d('Updating Wallet: ${walletModel.toJson()}', label: 'wallet');
    if (walletModel.id == null) {
      Log.e('Wallet ID is null, cannot update.');
      return false;
    }
    final companion = walletModel.toCompanion();
    return await update(wallets).replace(companion);
  }

  /// Deletes a wallet by its ID.
  Future<int> deleteWallet(int id) {
    Log.d('Deleting Wallet with ID: $id', label: 'wallet');
    return (delete(wallets)..where((w) => w.id.equals(id))).go();
  }

  Future<void> upsertWallet(WalletModel walletModel) async {
    Log.d('Upserting Wallet: ${walletModel.toJson()}', label: 'wallet');
    // For upsert, if ID is null, it's an insert.
    // If ID is present, it's an update on conflict.
    // The toCompanion handles Value.absent() for ID on insert.
    final companion = WalletsCompanion(
      id: walletModel.id == null
          ? const Value.absent()
          : Value(walletModel.id!),
      name: Value(walletModel.name.trim()),
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
