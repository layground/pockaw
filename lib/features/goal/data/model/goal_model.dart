import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

/// Represents a financial goal.
@freezed
class GoalModel with _$GoalModel {
  const factory GoalModel({
    /// The unique identifier for the goal. Null if the goal is new and not yet saved.
    int? id,

    /// The name or title of the financial goal (e.g., "New Laptop", "Vacation Fund").
    required String title,

    /// The target monetary amount for the goal.
    required double targetAmount,

    /// The current amount saved towards the goal. Defaults to 0.0.
    @Default(0.0) double currentAmount,

    /// The optional deadline date by which the goal should be achieved.
    DateTime? startDate,
    required DateTime endDate,

    /// The identifier or name of the icon associated with this goal.
    String? iconName,

    /// An optional description for the goal.
    String? description,

    /// The date when the goal was created.
    DateTime? createdAt,

    /// Optional ID of an associated account or fund source for this goal.
    int? associatedAccountId,
  }) = _GoalModel;

  /// Creates a `GoalModel` instance from a JSON map.
  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);
}

/// Utility extensions for the [GoalModel].
extension GoalModelUtils on GoalModel {
  /// Calculates the amount remaining to reach the target.
  /// Returns 0 if the current amount exceeds or meets the target.
  double get remainingAmount =>
      (targetAmount - currentAmount).clamp(0.0, double.infinity);

  /// Calculates the progress towards the goal as a percentage (0.0 to 100.0).
  /// Returns 0.0 if targetAmount is 0 or negative to avoid division by zero.
  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return ((currentAmount / targetAmount) * 100).clamp(0.0, 100.0);
  }

  /// Checks if the goal has been achieved (current amount is greater than or equal to target amount).
  bool get isAchieved => currentAmount >= targetAmount;

  /// Calculates the number of days left until the deadline.
  /// Returns null if there is no deadline.
  /// Returns a negative number if the deadline has passed.
  int? get daysLeft {
    final now = DateTime.now();
    // Compare date parts only to ensure 'today' counts as 0 days left if it's the deadline
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(endDate.year, endDate.month, endDate.day);
    return deadlineDay.difference(today).inDays;
  }

  /// Checks if the goal is overdue (deadline has passed and goal is not achieved).
  bool get isOverdue {
    final dl = daysLeft;
    return dl != null && dl < 0 && !isAchieved;
  }

  List<DateTime> get goalDates => [
    startDate ?? endDate.subtract(Duration(days: 1)),
    endDate,
  ];
}
