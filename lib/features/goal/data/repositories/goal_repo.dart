import 'package:pockaw/features/goal/data/model/goal_model.dart';

final GoalModel goalDummy = GoalModel(
  id: 0,
  title: '',
  targetAmount: 0,
  endDate: DateTime.now(),
);

final List<GoalModel> goals = [
  GoalModel(
    id: 1,
    title: 'New Laptop for Work',
    targetAmount: 1200.00,
    currentAmount: 750.00,
    endDate: DateTime.now().add(
      const Duration(days: 90),
    ), // Approx 3 months from now
    iconName: 'HugeIcons.strokeRoundedLaptop', // Example icon name
    description: 'Upgrade to a new MacBook Pro for better performance.',
    createdAt: DateTime.now().subtract(
      const Duration(days: 30),
    ), // Created a month ago
  ),
  GoalModel(
    id: 2,
    title: 'Summer Vacation to Bali',
    targetAmount: 2500.00,
    currentAmount: 1800.50,
    endDate: DateTime.now().add(
      const Duration(days: 150),
    ), // Approx 5 months from now
    iconName: 'HugeIcons.strokeRoundedBeach', // Example icon name
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    associatedAccountId: 1, // Example associated account
  ),
  GoalModel(
    id: 3,
    title: 'Emergency Fund',
    targetAmount: 5000.00,
    currentAmount: 5000.00, // Achieved
    iconName: 'HugeIcons.strokeRoundedBank', // Example icon name
    description: '6 months of living expenses.',
    endDate: DateTime.now().subtract(
      const Duration(days: 365),
    ), // Created a year ago
  ),
  GoalModel(
    id: 4,
    title: 'Learn Guitar Course',
    targetAmount: 300.00,
    currentAmount: 150.00,
    endDate: DateTime.now().subtract(const Duration(days: 10)), // Overdue
    iconName: 'HugeIcons.strokeRoundedMusicNote01', // Example icon name
    createdAt: DateTime.now().subtract(const Duration(days: 70)),
  ),
  GoalModel(
    // No ID, perhaps a new goal yet to be saved
    title: 'Weekend Getaway',
    targetAmount: 400.00,
    currentAmount: 50.00,
    iconName: 'HugeIcons.strokeRoundedMap', // Example icon name
    createdAt: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 50)),
  ),
  GoalModel(
    id: 5,
    title: 'Down Payment for Car',
    targetAmount: 3000.00,
    currentAmount: 250.75,
    endDate: DateTime.now().add(const Duration(days: 200)),
  ),
];
