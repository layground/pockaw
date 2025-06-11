import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// Helper to find a category by title, with a fallback.
CategoryModel _getCategoryByTitle(String title, {CategoryModel? fallback}) {
  return allCategories.firstWhere(
    (cat) => cat.title.toLowerCase() == title.toLowerCase(),
    orElse: () => fallback ?? allCategories.first,
  );
}

final allCategories = categories.getAllCategories();

final List<Transaction> transactions = [
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.income,
    amount: 1500.00,
    date: DateTime.now().subtract(const Duration(days: 5)),
    title: 'Monthly Salary',
    // Assuming 'Salary' might not be a direct category, using a general one or first available.
    // For a real app, you'd likely have an "Income" or "Salary" category.
    category: _getCategoryByTitle(
      'Entertainment',
      fallback: allCategories.firstWhere((c) => c.title == 'Shopping'),
    ), // Placeholder
    wallet: wallets[0], // Primary Checking
    notes: 'Received payment for May.',
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.expense,
    amount: 45.50,
    date: DateTime.now().subtract(const Duration(days: 2)),
    title: 'Groceries',
    category: allCategories.firstWhere((cat) => cat.title == 'Groceries'),
    wallet: wallets[0], // Primary Checking
    imagePath: '/app/images/receipt_groceries.jpg',
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.transfer,
    amount: 200.00,
    date: DateTime.now().subtract(const Duration(days: 1)),
    title: 'Transfer to Savings',
    // Transfers might not always have a typical expense/income category.
    // Using a general one or a specific "Transfers" category if available.
    category: _getCategoryByTitle(
      'Shopping',
      fallback: allCategories.firstWhere((c) => c.title == 'Shopping'),
    ), // Placeholder for "Savings" / "Transfer"
    wallet: wallets[1], // Savings Account
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.expense,
    amount: 12.99,
    date: DateTime.now().subtract(const Duration(hours: 3)),
    title: 'Coffee & Pastry',
    category: allCategories.firstWhere((cat) => cat.title == 'Coffee Shops'),
    wallet: wallets[2], // Naira Wallet
    isRecurring: false, // Example of non-recurring flag
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.income,
    amount: 250.00,
    date: DateTime.now().subtract(const Duration(days: 10, hours: 2)),
    title: 'Freelance Project Payment',
    category: _getCategoryByTitle(
      'Entertainment',
      fallback: allCategories.firstWhere((c) => c.title == 'Shopping'),
    ), // Placeholder for "Freelance"
    wallet: wallets[0], // Primary Checking
    notes: 'Payment for website design mockups.',
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.expense,
    amount: 78.20,
    date: DateTime.now().subtract(const Duration(days: 3, hours: 5)),
    title: 'Dinner with Friends',
    category: allCategories.firstWhere((cat) => cat.title == 'Restaurants'),
    wallet: wallets[3], // Vacation Fund (EUR) - example
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.expense,
    amount: 19.99,
    date: DateTime.now().subtract(const Duration(days: 7)),
    title: 'Online Streaming Subscription',
    category: allCategories.firstWhere((cat) => cat.title == 'Entertainment'),
    wallet: wallets[0], // Primary Checking
    isRecurring: true,
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.transfer,
    amount: 500.00,
    date: DateTime.now().subtract(const Duration(days: 4)),
    title: 'To Investment Account',
    category: _getCategoryByTitle(
      'Shopping',
      fallback: allCategories.firstWhere((c) => c.title == 'Shopping'),
    ), // Placeholder for "Investment"
    wallet: wallets[1], // Savings Account
    notes: 'Monthly investment contribution.',
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.expense,
    amount: 55.00,
    date: DateTime.now().subtract(const Duration(days: 6, hours: 10)),
    title: 'Gasoline Fill-up',
    category: allCategories.firstWhere((cat) => cat.title == 'Fuel'),
    wallet: wallets[2], // Naira Wallet
    imagePath: '/app/images/gas_receipt.png',
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.income,
    amount: 75.00,
    date: DateTime.now().subtract(const Duration(days: 12)),
    title: 'Sold Old Books',
    category: _getCategoryByTitle(
      'Shopping',
      fallback: allCategories.firstWhere((c) => c.title == 'Shopping'),
    ), // Placeholder for "Other Income"
    wallet: wallets[0], // Primary Checking
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.expense,
    amount: 29.95,
    date: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    title: 'New T-shirt',
    category: allCategories.firstWhere((cat) => cat.title == 'Clothing'),
    wallet: wallets[3], // Vacation Fund
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.expense,
    amount: 90.00,
    date: DateTime.now().subtract(const Duration(days: 15)),
    title: 'Electricity Bill',
    category: allCategories.firstWhere(
      (cat) => cat.title == 'Housing',
    ), // "Housing" can cover utilities
    wallet: wallets[0], // Primary Checking
    isRecurring: true,
    notes: 'Higher than usual due to AC usage.',
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.transfer,
    amount: 150.00,
    date: DateTime.now().subtract(const Duration(days: 8)),
    title: 'Internal Transfer to Checking',
    category: _getCategoryByTitle(
      'Shopping',
      fallback: allCategories.firstWhere((c) => c.title == 'Shopping'),
    ), // Placeholder for "Internal Transfer"
    wallet:
        wallets[1], // Savings Account (source) or wallets[0] (destination) - depends on perspective
  ),
  Transaction(
    id: _uuid.v4(),
    transactionType: TransactionType.income,
    amount: 15.00,
    date: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    title: 'Survey Reward',
    category: _getCategoryByTitle(
      'Entertainment',
      fallback: allCategories.firstWhere((c) => c.title == 'Shopping'),
    ), // Placeholder
    wallet: wallets[2], // Naira Wallet
    imagePath: '/app/images/survey_reward.jpg',
  ),
];
