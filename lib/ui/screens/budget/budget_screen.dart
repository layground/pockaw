import 'package:flutter/material.dart';
import 'package:pockaw/ui/widgets/scaffolds/custom_scaffold.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      showBackButton: false,
      body: const Center(
        child: Text('Budget'),
      ),
    );
  }
}
