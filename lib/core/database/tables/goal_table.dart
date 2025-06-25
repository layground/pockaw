import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';

@DataClassName('Goal')
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get iconName => text().nullable()();
  IntColumn get associatedAccountId => integer().nullable()();
}

extension GoalExtension on Goal {
  /// Creates a [Goal] instance from a map, typically from JSON deserialization.
  Goal fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      targetAmount: json['targetAmount'] as double,
      currentAmount: json['currentAmount'] as double,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      iconName: json['iconName'] as String?,
      associatedAccountId: json['associatedAccountId'] as int?,
    );
  }
}

extension GoalTableExtensions on Goal {
  /// Converts this Drift [Goal] data class to a [GoalModel].
  ///
  /// Note: Some fields in [GoalModel] like `targetAmount`, `currentAmount`,
  /// `iconName`, and `associatedAccountId` are not present in the [Goals] table
  /// and will be set to default or null values. // This comment will be outdated after changes.
  GoalModel toModel() {
    return GoalModel(
      id: id,
      title: title,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      iconName: iconName,
      description: description,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      associatedAccountId: associatedAccountId,
    );
  }
}
