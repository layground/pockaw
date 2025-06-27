import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';
// Assuming a WalletTable will exist, create a placeholder or actual import
// import 'package:pockaw/core/database/tables/wallet_table.dart'; // Placeholder

/// Represents the `transactions` table in the database.
@DataClassName('Transaction') // Defines the name of the generated data class
class Transactions extends Table {
  /// Unique identifier for the transaction (UUID string).
  IntColumn get id => integer().autoIncrement()();

  /// Type of transaction (0: income, 1: expense, 2: transfer).
  IntColumn get transactionType => integer()();

  /// Monetary amount of the transaction.
  RealColumn get amount => real()();

  /// Date and time of the transaction.
  DateTimeColumn get date => dateTime()();

  /// Title or short description of the transaction.
  TextColumn get title => text().withLength(min: 1, max: 255)();

  /// Foreign key referencing the [Categories] table.
  IntColumn get categoryId => integer().references(Categories, #id)();

  /// Foreign key referencing the `Wallets` table.
  /// Note: You'll need to create a `Wallets` table definition similar to `Categories`.
  /// For now, we define it, assuming `Wallets` table will have an `id` column.
  IntColumn get walletId => integer().references(Wallets, #id)();

  /// Optional notes for the transaction.
  TextColumn get notes => text().nullable()();

  /// Optional path to an image associated with the transaction.
  TextColumn get imagePath => text().nullable()();

  /// Flag indicating if the transaction is recurring.
  BoolColumn get isRecurring => boolean().nullable()();

  /// Timestamp of when the transaction was created in the database.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp of when the transaction was last updated in the database.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

extension TransactionExtension on Transaction {
  /// Creates a [Transaction] instance from a map, typically from JSON deserialization.
  Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      transactionType: json['transactionType'] as int,
      amount: json['amount'] as double,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      categoryId: json['categoryId'] as int,
      walletId: json['walletId'] as int,
      notes: json['notes'] as String?,
      imagePath: json['imagePath'] as String?,
      isRecurring: json['isRecurring'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Extension methods for the Drift-generated `Transaction` data class.
extension TransactionTableExtensions on Transaction {
  /// Converts a Drift `Transaction` data class instance (along with its related `Category`)
  /// to a domain `TransactionModel`.
  ///
  /// Note: This currently uses a placeholder for `WalletModel` from `wallet_repo.dart`.
  /// This should be updated once `WalletTable` and its fetching mechanism are in place.
  TransactionModel toModel({
    required CategoryModel category,
    // Wallet walletEntity, // Add this parameter when WalletTable is integrated
  }) {
    return TransactionModel(
      id: id,
      transactionType: TransactionTypeDBMapping.fromDbValue(transactionType),
      amount: amount,
      date: date,
      title: title,
      category: category,
      wallet: wallets.first,
      notes: notes,
      imagePath: imagePath,
      isRecurring: isRecurring,
    );
  }
}

// Helper extension to map between TransactionType enum and integer for DB storage
extension TransactionTypeDBMapping on TransactionType {
  int toDbValue() {
    return index; // Uses the natural enum index (income:0, expense:1, transfer:2)
  }

  static TransactionType fromDbValue(int value) {
    if (value >= 0 && value < TransactionType.values.length) {
      return TransactionType.values[value];
    }
    // Fallback or throw error if value is out of bounds
    throw ArgumentError('Invalid integer value for TransactionType: $value');
  }
}
