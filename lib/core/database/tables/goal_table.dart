import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/features/goal/data/model/goal_model.dart';

@DataClassName('Goal')
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
}

extension GoalTableExtensions on Goal {
  /// Converts this Drift [Goal] data class to a [GoalModel].
  ///
  /// Note: Some fields in [GoalModel] like `targetAmount`, `currentAmount`,
  /// `iconName`, and `associatedAccountId` are not present in the [Goals] table
  /// and will be set to default or null values.
  GoalModel toModel() {
    return GoalModel(
      id: id, // Convert int id to String
      title: title,
      targetAmount: 0.0, // Default value, as it's not in the Goals table
      currentAmount: 0.0, // Default value
      deadlineDate: endDate, // Map endDate to deadlineDate
      iconName: null, // Not in Goals table
      description: note, // Map note to description
      createdAt: startDate, // Map startDate to createdAt
      associatedAccountId: null, // Not in Goals table
    );
  }
}
