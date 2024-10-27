import 'package:buddyjet/ui/widgets/scaffolds/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalBudget = 2000.00;

  double spentAmount = 1200.00;

  @override
  Widget build(BuildContext context) {
    double remainingBudget = totalBudget - spentAmount;

    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: CustomFab(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting and summary
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Budget Summary
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total Budget: \$${totalBudget.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Spent: \$${spentAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Remaining: \$${remainingBudget.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to add transaction page
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Transaction'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to view budget page
                  },
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('View Budget'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Transactions Header
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Recent Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Example transaction count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: Text('Transaction ${index + 1}'),
                    subtitle: const Text('Category: Groceries'),
                    trailing: Text(
                      '-\$${(20.0 * (index + 1)).toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
