import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      showBackButton: false,
      title: 'My Transactions',
      showBalance: false,
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: TablerIcons.search,
        ),
        CustomIconButton(
          onPressed: () {},
          icon: TablerIcons.filter,
          iconSize: IconSize.medium,
        ),
      ],
      body: const Center(
        child: Text('Transaction'),
      ),
    );
  }
}
