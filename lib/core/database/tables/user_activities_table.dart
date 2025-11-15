import 'package:drift/drift.dart';
import 'package:pockaw/core/database/tables/users.dart';

@DataClassName('UserActivity')
class UserActivities extends Table {
  IntColumn get id => integer().autoIncrement()();

  // FK to Users.id
  IntColumn get userId => integer().references(Users, #id)();

  // Optional related object id (transaction id, wallet id, etc.)
  IntColumn get subjectId => integer().nullable()();

  TextColumn get action => text()();

  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  TextColumn get appVersion => text().withLength(min: 0, max: 64).nullable()();

  TextColumn get deviceModel => text().nullable()();

  BoolColumn get success => boolean().withDefault(const Constant(true))();

  TextColumn get metadata => text().nullable()();
}
