import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';

class TransactionNotesField extends HookConsumerWidget {
  final TextEditingController controller;

  const TransactionNotesField({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextField(
      context: context,
      controller: controller,
      label: 'Write a note (max. 500)',
      hint: 'Write here...',
      prefixIcon: HugeIcons.strokeRoundedNote02,
      minLines: 1,
      maxLines: 3,
      maxLength: 500,
      customCounterText: '',
    );
  }
}
