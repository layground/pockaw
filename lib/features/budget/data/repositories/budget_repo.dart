import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart'; // Import categories

// Helper to find a wallet by name (using firstWhere for simplicity in example)
final _myWallet = wallets.firstWhere((w) => w.name == 'My Wallet');
final _savingsAccount = wallets.firstWhere((w) => w.name == 'Savings Account');

// Helper to find a category by title (using getAllCategories for subcategories)
final _groceriesCategory = categories.getAllCategories().firstWhere(
  (cat) => cat.title == 'Groceries',
);
final _utilitiesCategory = categories.firstWhere(
  (cat) => cat.title == 'Utilities',
);
final _entertainmentCategory = categories.firstWhere(
  (cat) => cat.title == 'Entertainment',
);
final _transportCategory = categories.firstWhere(
  (cat) => cat.title == 'Transportation',
);
final _shoppingCategory = categories.firstWhere(
  (cat) => cat.title == 'Shopping',
);

final List<BudgetModel> budgets = [
  BudgetModel(
    id: 1, // Use integer ID
    wallet: _myWallet, // Use WalletModel instance
    category: _groceriesCategory, // Use CategoryModel instance
    amount: 150.00,
    startDate: DateTime.now().subtract(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 25)),
    isRoutine: false,
  ),
  BudgetModel(
    id: 2, // Use integer ID
    wallet: _savingsAccount, // Use WalletModel instance
    category: _utilitiesCategory, // Use CategoryModel instance
    amount: 75.50,
    startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
    endDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0, // Last day of current month
    ),
    isRoutine: true,
  ),
  BudgetModel(
    id: 3, // Use integer ID
    wallet: _myWallet, // Use WalletModel instance
    category: _entertainmentCategory, // Use CategoryModel instance
    amount: 200.00,
    startDate: DateTime.now().add(const Duration(days: 10)),
    endDate: DateTime.now().add(const Duration(days: 40)),
    isRoutine: false,
  ),
  BudgetModel(
    // No ID, represents a new budget
    wallet:
        _myWallet, // Use WalletModel instance (using My Wallet as Cash isn't defined)
    category: _transportCategory, // Use CategoryModel instance
    amount: 50.00,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 6)), // Weekly budget
    isRoutine: true,
  ),
  BudgetModel(
    id: 4, // Use integer ID
    wallet:
        _myWallet, // Use WalletModel instance (using My Wallet as Credit Card isn't defined)
    category: _shoppingCategory, // Use CategoryModel instance
    amount: 300.75,
    startDate: DateTime.now().subtract(const Duration(days: 15)),
    endDate: DateTime.now().add(const Duration(days: 15)),
    isRoutine: false,
  ),
];
