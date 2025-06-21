import 'package:drift/drift.dart';
import 'package:pockaw/core/database/tables/category_table.dart';
import 'package:pockaw/core/database/tables/wallet_table.dart';

@DataClassName('Budget') // Name of the generated data class
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isRoutine => boolean()();
}
