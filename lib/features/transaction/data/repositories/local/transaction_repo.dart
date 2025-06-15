import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';

// Helper to find a category by title, with a fallback.
// It now searches both parent and sub-category titles.
CategoryModel _getCategoryByTitle(String title, {CategoryModel? fallback}) {
  final allFlattenedCategories = categories.getAllCategories();
  return allFlattenedCategories.firstWhere(
    (cat) => cat.title.toLowerCase() == title.toLowerCase(),
    orElse: () => fallback ?? allFlattenedCategories.first,
  );
}

int _transactionIdCounter = 0;

final List<TransactionModel> transactions = [
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.income,
    amount: 1500.00,
    date: DateTime.now().subtract(const Duration(days: 5)),
    title: 'Monthly Salary',
    category: _getCategoryByTitle(
      'Salary/Wages', // Matches sub-category under "Income"
      fallback: _getCategoryByTitle('Income'),
    ),
    wallet: wallets[0], // Primary Checking
    notes: 'Received payment for May.',
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.expense,
    amount: 45.50,
    date: DateTime.now().subtract(const Duration(days: 2)),
    title: 'Groceries',
    category: _getCategoryByTitle('Groceries'),
    wallet: wallets[0], // Primary Checking
    imagePath: '/app/images/receipt_groceries.jpg',
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.transfer,
    amount: 200.00,
    date: DateTime.now().subtract(const Duration(days: 1)),
    title: 'Transfer to Savings',
    category: _getCategoryByTitle(
      'General Savings', // Matches sub-category under "Savings"
      fallback: _getCategoryByTitle('Savings'),
    ),
    wallet: wallets[1], // Savings Account
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.expense,
    amount: 12.99,
    date: DateTime.now().subtract(const Duration(hours: 3)),
    title: 'Coffee & Pastry',
    category: _getCategoryByTitle(
      'Restaurants & Cafes',
    ), // More general sub-category
    wallet: wallets[2], // Naira Wallet
    isRecurring: false, // Example of non-recurring flag
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.income,
    amount: 250.00,
    date: DateTime.now().subtract(const Duration(days: 10, hours: 2)),
    title: 'Freelance Project Payment',
    category: _getCategoryByTitle(
      'Freelance/Consulting', // Matches sub-category under "Income"
      fallback: _getCategoryByTitle('Income'),
    ),
    wallet: wallets[0], // Primary Checking
    notes: 'Payment for website design mockups.',
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.expense,
    amount: 78.20,
    date: DateTime.now().subtract(const Duration(days: 3, hours: 5)),
    title: 'Dinner with Friends',
    category: _getCategoryByTitle('Restaurants & Cafes'),
    wallet: wallets[3], // Vacation Fund (EUR) - example
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.expense,
    amount: 19.99,
    date: DateTime.now().subtract(const Duration(days: 7)),
    title: 'Online Streaming Subscription',
    category: _getCategoryByTitle('Streaming Services'),
    wallet: wallets[0], // Primary Checking
    isRecurring: true,
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.transfer,
    amount: 500.00,
    date: DateTime.now().subtract(const Duration(days: 4)),
    title: 'To Investment Account',
    category: _getCategoryByTitle(
      'Stocks', // Example sub-category under "Investments"
      fallback: _getCategoryByTitle('Investments'),
    ),
    wallet: wallets[1], // Savings Account
    notes: 'Monthly investment contribution.',
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.expense,
    amount: 55.00,
    date: DateTime.now().subtract(const Duration(days: 6, hours: 10)),
    title: 'Gasoline Fill-up',
    category: _getCategoryByTitle('Fuel/Gas'),
    wallet: wallets[2], // Naira Wallet
    imagePath: '/app/images/gas_receipt.png',
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.income,
    amount: 75.00,
    date: DateTime.now().subtract(const Duration(days: 12)),
    title: 'Sold Old Books',
    category: _getCategoryByTitle(
      'Miscellaneous', // Using a general category for less common income
      fallback: _getCategoryByTitle('Income'),
    ),
    wallet: wallets[0], // Primary Checking
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.expense,
    amount: 29.95,
    date: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    title: 'New T-shirt',
    category: _getCategoryByTitle('Clothing & Accessories'),
    wallet: wallets[3], // Vacation Fund
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.expense,
    amount: 90.00,
    date: DateTime.now().subtract(const Duration(days: 15)),
    title: 'Electricity Bill',
    category: _getCategoryByTitle('Electricity'), // Specific sub-category
    wallet: wallets[0], // Primary Checking
    isRecurring: true,
    notes: 'Higher than usual due to AC usage.',
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.transfer,
    amount: 150.00,
    date: DateTime.now().subtract(const Duration(days: 8)),
    title: 'Internal Transfer to Checking',
    category: _getCategoryByTitle(
      'Miscellaneous', // Or a specific "Internal Transfer" category if you add one
      fallback: _getCategoryByTitle('Savings'),
    ),
    wallet:
        wallets[1], // Savings Account (source) or wallets[0] (destination) - depends on perspective
  ),
  TransactionModel(
    id: ++_transactionIdCounter,
    transactionType: TransactionType.income,
    amount: 15.00,
    date: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    title: 'Survey Reward',
    category: _getCategoryByTitle(
      'Miscellaneous', // General income
      fallback: _getCategoryByTitle('Income'),
    ),
    wallet: wallets[2], // Naira Wallet
    imagePath: '/app/images/survey_reward.jpg',
  ),
];
