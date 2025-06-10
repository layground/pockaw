import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final List<BudgetModel> budgets = [
  BudgetModel(
    id: _uuid.v4(),
    fundSource: 'Primary Wallet',
    categoryId: 'groceries_cat_id', // Replace with actual category ID
    amount: 150.00,
    startDate: DateTime.now().subtract(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 25)),
    isRoutine: false,
  ),
  BudgetModel(
    id: _uuid.v4(),
    fundSource: 'Savings Account',
    categoryId: 'utilities_cat_id', // Replace with actual category ID
    amount: 75.50,
    startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
    endDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
    ), // Last day of current month
    isRoutine: true,
  ),
  BudgetModel(
    id: _uuid.v4(),
    fundSource: 'Primary Wallet',
    categoryId: 'entertainment_cat_id', // Replace with actual category ID
    amount: 200.00,
    startDate: DateTime.now().add(const Duration(days: 10)),
    endDate: DateTime.now().add(const Duration(days: 40)),
    isRoutine: false,
  ),
  BudgetModel(
    // No ID, perhaps a new budget yet to be saved
    fundSource: 'Cash',
    categoryId: 'transport_cat_id', // Replace with actual category ID
    amount: 50.00,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 6)), // Weekly budget
    isRoutine: true,
  ),
  BudgetModel(
    id: _uuid.v4(),
    fundSource: 'Credit Card',
    categoryId: 'shopping_cat_id', // Replace with actual category ID
    amount: 300.75,
    startDate: DateTime.now().subtract(const Duration(days: 15)),
    endDate: DateTime.now().add(const Duration(days: 15)),
    isRoutine: false,
  ),
];
