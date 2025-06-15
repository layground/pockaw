import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';

@DataClassName('Wallet')
class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('My Wallet'))();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('IDR'))();
  TextColumn get iconName => text().nullable()();
  TextColumn get colorHex => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

extension WalletTableExtensions on Wallet {
  WalletModel toModel() {
    return WalletModel(
      id: id,
      name: name,
      balance: balance,
      currency: currency,
      iconName: iconName,
      colorHex: colorHex,
    );
  }
}

extension WalletModelExtensions on WalletModel {
  WalletsCompanion toCompanion({bool isInsert = false}) {
    return WalletsCompanion(
      // If it's a true insert (like initial population), ID should be absent
      // so the database can auto-increment.
      id: isInsert
          ? const Value.absent()
          : (id == null ? const Value.absent() : Value(id!)),
      name: Value(name),
      balance: Value(balance),
      currency: Value(currency),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      // createdAt is handled by default on insert
      createdAt: isInsert ? Value(DateTime.now()) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
  }
}
