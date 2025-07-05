import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/transaction_table.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart'; // Import WalletTable
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/transaction/data/model/transaction_filter_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(
  tables: [Transactions, Categories, Wallets], // Add Wallets table
)
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Helper to convert a database row (Transaction, Category, Wallet) to a TransactionModel.
  Future<TransactionModel> _mapToTransactionModel(
    Transaction transactionData,
    Category categoryData,
    Wallet walletData,
  ) async {
    return TransactionModel(
      id: transactionData.id,
      // Use the actual enum value from the database integer
      // This is safer than relying on index directly if enum order changes
      transactionType: TransactionType.values.firstWhere(
        (e) => e.index == transactionData.transactionType,
      ),
      amount: transactionData.amount,
      date: transactionData.date,
      title: transactionData.title,
      category: categoryData.toModel(), // Using CategoryTableExtensions
      wallet: walletData.toModel(), // Replace with actual fetched WalletModel
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
      innerJoin(
        db.wallets,
        db.wallets.id.equalsExp(transactions.walletId),
      ), // Use db.wallets
    ]);

    return query.watch().asyncMap((rows) async {
      final result = <TransactionModel>[];
      for (final row in rows) {
        final transactionData = row.readTable(transactions);
        final categoryData = row.readTable(categories);
        final walletData = row.readTable(db.wallets); // Use db.wallets
        result.add(
          await _mapToTransactionModel(
            transactionData,
            categoryData,
            walletData,
          ),
        );
      }
      return result;
    });
  }

  /// Watches all transactions for a specific wallet with their associated category and wallet details.
  Stream<List<TransactionModel>> watchTransactionsByWalletIdWithDetails(
    int walletId,
  ) {
    Log.d(
      '🔍 Subscribing to watchTransactionsByWalletIdWithDetails($walletId)',
    );
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(db.wallets, db.wallets.id.equalsExp(transactions.walletId)),
    ])..where(transactions.walletId.equals(walletId)); // Filter by walletId

    return query.watch().asyncMap((rows) async {
      final result = <TransactionModel>[];
      for (final row in rows) {
        final transactionData = row.readTable(transactions);
        final categoryData = row.readTable(categories);
        final walletData = row.readTable(db.wallets);
        result.add(
          await _mapToTransactionModel(
            transactionData,
            categoryData,
            walletData,
          ),
        );
      }
      return result;
    });
  }

  // Get transactions for a specific budget period, category, and wallet
  Future<List<TransactionModel>> getTransactionsForBudget({
    required List<int> categoryIds,
    required DateTime startDate,
    required DateTime endDate,
    required int walletId,
  }) async {
    // We need to join with Categories and Wallets to get the full TransactionModel
    final query =
        select(transactions).join([
            innerJoin(
              categories,
              categories.id.equalsExp(transactions.categoryId),
            ),
            innerJoin(
              db.wallets,
              db.wallets.id.equalsExp(transactions.walletId),
            ),
          ])
          ..where(transactions.categoryId.isIn(categoryIds))
          ..where(transactions.date.isBetweenValues(startDate, endDate))
          ..where(transactions.walletId.equals(walletId))
          ..where(
            transactions.transactionType.equals(TransactionType.expense.index),
          ); // Only expenses

    final rows = await query.get();
    final result = <TransactionModel>[];
    for (final row in rows) {
      final transactionData = row.readTable(transactions);
      final categoryData = row.readTable(categories);
      final walletData = row.readTable(db.wallets);
      result.add(
        await _mapToTransactionModel(transactionData, categoryData, walletData),
      );
    }

    Log.d(result, label: 'transactions by budget');

    return result;
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
      walletId: Value(
        transactionModel.wallet.id!,
      ), // Assuming wallet.id will not be null here
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
      // For `update(table).replace(companion)`, the companion must include the primary key.
      // transactionModel.id is expected to be non-null for an update operation.
      // The TransactionFormState includes a check to ensure transactionToSave.id is not null before calling update.
      id: Value(transactionModel.id!),
      transactionType: Value(transactionModel.transactionType.toDbValue()),
      amount: Value(transactionModel.amount),
      date: Value(transactionModel.date),
      title: Value(transactionModel.title),
      categoryId: Value(transactionModel.category.id!),
      walletId: Value(
        transactionModel.wallet.id!,
      ), // Assuming wallet.id will not be null here
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
      walletId: Value(
        transactionModel.wallet.id!,
      ), // Assuming wallet.id will not be null here
      notes: Value(transactionModel.notes),
      imagePath: Value(transactionModel.imagePath),
      isRecurring: Value(transactionModel.isRecurring),
      // Let createdAt be handled by DB default on insert, updatedAt always changes
      updatedAt: Value(DateTime.now()),
    );
    return into(transactions).insertOnConflictUpdate(companion);
  }

  /// Watches filtered transactions for a specific wallet with their associated category and wallet details.
  Stream<List<TransactionModel>> watchFilteredTransactionsWithDetails({
    required int walletId,
    TransactionFilter? filter,
  }) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(db.wallets, db.wallets.id.equalsExp(transactions.walletId)),
    ])..where(transactions.walletId.equals(walletId));

    if (filter != null) {
      if (filter.transactionType != null) {
        query.where(
          transactions.transactionType.equals(filter.transactionType!.index),
        );
      }
      if (filter.category != null) {
        query.where(transactions.categoryId.equals(filter.category!.id!));
      }
      if (filter.minAmount != null) {
        query.where(
          transactions.amount.isBiggerOrEqualValue(filter.minAmount!),
        );
      }
      if (filter.maxAmount != null) {
        query.where(
          transactions.amount.isSmallerOrEqualValue(filter.maxAmount!),
        );
      }
      if (filter.keyword != null && filter.keyword!.isNotEmpty) {
        query.where(transactions.title.like('%${filter.keyword!}%'));
        query.where(transactions.notes.like('%${filter.keyword!}%'));
      }
      if (filter.dateStart != null && filter.dateEnd != null) {
        query.where(
          transactions.date.isBetweenValues(filter.dateStart!, filter.dateEnd!),
        );
      }
    }

    return query.watch().asyncMap((rows) async {
      final result = <TransactionModel>[];
      for (final row in rows) {
        final transactionData = row.readTable(transactions);
        final categoryData = row.readTable(categories);
        final walletData = row.readTable(db.wallets);
        result.add(
          await _mapToTransactionModel(
            transactionData,
            categoryData,
            walletData,
          ),
        );
      }
      return result;
    });
  }
}
