import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';

class TransactionTitleField extends HookConsumerWidget {
  final TextEditingController controller;
  final bool isEditing;

  const TransactionTitleField({
    super.key,
    required this.controller,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextField(
      controller: controller,
      label: 'Title',
      hint: 'Lunch with my friends',
      prefixIcon: HugeIcons.strokeRoundedArrangeByLettersAZ,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      isRequired: true,
      autofocus: !isEditing,
    );
  }
}
