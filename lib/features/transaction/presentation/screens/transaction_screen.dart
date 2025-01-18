import 'package:flutter/material.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      showBackButton: false,
      body: const Center(
        child: Text('Transaction'),
      ),
    );
  }
}
