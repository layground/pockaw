import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';

class TransactionFilterTypeSelector extends HookConsumerWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeSelected;

  const TransactionFilterTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.spacing4,
      children: TransactionType.values.map((type) {
        String label;
        switch (type) {
          case TransactionType.income:
            label = 'Income';
            break;
          case TransactionType.expense:
            label = 'Expense';
            break;
          case TransactionType.transfer:
            label = 'Transfer';
            break;
        }
        return Expanded(
          child: ButtonChip(
            label: label,
            active: selectedType == type,
            onTap: () => onTypeSelected(type),
          ),
        );
      }).toList(),
    );
  }
}
