import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';

class TransactionAmountField extends HookConsumerWidget {
  final TextEditingController controller;
  final String defaultCurrency;
  final bool autofocus;

  const TransactionAmountField({
    super.key,
    required this.controller,
    required this.defaultCurrency,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomNumericField(
      controller: controller,
      label: 'Amount',
      hint: '$defaultCurrency 0.00',
      icon: HugeIcons.strokeRoundedCoins01,
      isRequired: true,
      autofocus: autofocus,
    );
  }
}
