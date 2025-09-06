import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

/// Represents a budget item with its details.
@freezed
abstract class BudgetModel with _$BudgetModel {
  /// The unique identifier for the budget. Null if the budget is new and not yet saved.
  const factory BudgetModel({
    int? id,

    /// The source of funds for this budget (e.g., "Primary Wallet", "Savings Account").
    required WalletModel wallet,

    /// The identifier of the category this budget belongs to.
    required CategoryModel category,

    /// The allocated amount for this budget.
    required double amount,

    /// The start date of the budget period.
    required DateTime startDate,

    /// The end date of the budget period.
    required DateTime endDate,

    /// Indicates whether this budget is a recurring or routine budget.
    required bool isRoutine,
  }) = _BudgetModel;

  /// Creates a `BudgetModel` instance from a JSON map.
  /// Expects dates to be in ISO 8601 string format.
  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);
}

/// Utility extensions for the [BudgetModel].
extension BudgetModelUtils on BudgetModel {
  /// Calculates the duration of the budget period.
  Duration get periodDuration => endDate.difference(startDate);

  /// Checks if the budget is currently active based on the current date.
  /// Considers a budget active if the current date is between [startDate] (inclusive)
  /// and [endDate] (inclusive), comparing date parts only.
  bool get isCurrentlyActive {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final budgetStartDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final budgetEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    return (today.isAtSameMomentAs(budgetStartDate) ||
            today.isAfter(budgetStartDate)) &&
        (today.isAtSameMomentAs(budgetEndDate) ||
            today.isBefore(budgetEndDate));
  }
}
