import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/transaction_table.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(
  tables: [Transactions, Categories /*, Wallets */],
) // Add Wallets when defined
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Helper to convert a database row (Transaction, Category, Wallet) to a TransactionModel.
  /// This assumes you have a way to fetch Wallet data. For simplicity,
  /// a placeholder WalletModel is used. Replace with actual Wallet fetching.
  Future<TransactionModel> _mapToTransactionModel(
    Transaction transactionData,
    Category categoryData,
    // Wallet walletData, // Uncomment when Wallet table/DAO is ready
  ) async {
    return TransactionModel(
      id: transactionData.id,
      transactionType: TransactionType.expense,
      amount: transactionData.amount,
      date: transactionData.date,
      title: transactionData.title,
      category: categoryData.toModel(), // Using CategoryTableExtensions
      wallet: wallets.first, // Replace with actual fetched WalletModel
      notes: transactionData.notes,
      imagePath: transactionData.imagePath,
      isRecurring: transactionData.isRecurring,
    );
  }

  /// Streams all transactions; logs each emission
  Future<List<Transaction>> getAllTransactions() {
    Log.d('🔍  Subscribing to getAllTransactions()');
    return select(transactions).get();
  }

  /// Streams all transactions; logs each emission
  Stream<List<Transaction>> watchAllTransactions() {
    Log.d('🔍  Subscribing to watchAllTransactions()');
    return select(transactions).watch().map((list) {
      Log.d('📋  watchAllTransactions emitted ${list.length} rows');
      return list;
    });
  }

  /// Streams single transaction;
  Stream<Transaction> watchTransactionByID(int id) {
    Log.d('🔍  Subscribing to watchTransactionByID($id)');
    return (select(transactions)..where((g) => g.id.equals(id))).watchSingle();
  }

  /// Watches all transactions with their associated category and wallet details.
  Stream<List<TransactionModel>> watchAllTransactionsWithDetails() {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      // innerJoin(wallets, wallets.id.equalsExp(transactions.walletId)), // Uncomment when Wallets table is ready
    ]);

    return query.watch().asyncMap((rows) async {
      final result = <TransactionModel>[];
      for (final row in rows) {
        final transactionData = row.readTable(transactions);
        final categoryData = row.readTable(categories);
        // final walletData = row.readTable(wallets); // Uncomment
        result.add(
          await _mapToTransactionModel(
            transactionData,
            categoryData,
            /* walletData */
          ),
        );
      }
      return result;
    });
  }

  /// Inserts a new transaction.
  Future<int> addTransaction(TransactionModel transactionModel) async {
    Log.d('Saving New Transaction: ${transactionModel.toJson()}');
    final companion = TransactionsCompanion(
      transactionType: Value(transactionModel.transactionType.toDbValue()),
      amount: Value(transactionModel.amount),
      date: Value(transactionModel.date),
      title: Value(transactionModel.title),
      categoryId: Value(transactionModel.category.id!),
      walletId: Value(transactionModel.wallet.id),
      notes: Value(transactionModel.notes),
      imagePath: Value(transactionModel.imagePath),
      isRecurring: Value(transactionModel.isRecurring),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    return await into(transactions).insert(companion);
  }

  /// Updates an existing transaction.
  Future<bool> updateTransaction(TransactionModel transactionModel) async {
    Log.d('Updating Transaction: ${transactionModel.toJson()}');
    final companion = TransactionsCompanion(
      transactionType: Value(transactionModel.transactionType.toDbValue()),
      amount: Value(transactionModel.amount),
      date: Value(transactionModel.date),
      title: Value(transactionModel.title),
      categoryId: Value(transactionModel.category.id!),
      walletId: Value(transactionModel.wallet.id),
      notes: Value(transactionModel.notes),
      imagePath: Value(transactionModel.imagePath),
      isRecurring: Value(transactionModel.isRecurring),
      updatedAt: Value(DateTime.now()),
    );
    return await update(transactions).replace(companion);
  }

  /// Deletes a transaction by its ID.
  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Upserts a transaction: inserts if new, updates if exists by ID.
  Future<void> upsertTransaction(TransactionModel transactionModel) {
    final companion = TransactionsCompanion(
      id: Value(transactionModel.id ?? 0),
      transactionType: Value(transactionModel.transactionType.toDbValue()),
      amount: Value(transactionModel.amount),
      date: Value(transactionModel.date),
      title: Value(transactionModel.title),
      categoryId: Value(transactionModel.category.id!),
      walletId: Value(transactionModel.wallet.id),
      notes: Value(transactionModel.notes),
      imagePath: Value(transactionModel.imagePath),
      isRecurring: Value(transactionModel.isRecurring),
      // Let createdAt be handled by DB default on insert, updatedAt always changes
      updatedAt: Value(DateTime.now()),
    );
    return into(transactions).insertOnConflictUpdate(companion);
  }
}
