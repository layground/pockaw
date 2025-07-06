import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/date_picker/custom_date_picker.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart';

class TransactionFilterDatePicker extends HookConsumerWidget {
  final TextEditingController controller;
  const TransactionFilterDatePicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context, ref) {
    final selectedDateRange = ref.watch(filterDatePickerProvider);
    final selectedDateNotifier = ref.read(filterDatePickerProvider.notifier);

    useEffect(() {
      controller.text =
          '${selectedDateRange.first?.toRelativeDayFormatted()} - ${selectedDateRange.last?.toRelativeDayFormatted()}';
      return null;
    }, []);

    return CustomSelectField(
      context: context,
      controller: controller,
      label: 'Set a date range',
      hint: '1 June 2025 - 31 July 2024',
      prefixIcon: HugeIcons.strokeRoundedCalendar01,
      onTap: () async {
        var range = await CustomDatePicker.selectDateRange(
          context,
          selectedDateRange,
        );

        if (range != null) {
          selectedDateNotifier.state = range;
          Log.d(range, label: 'selected date');
          controller.text =
              '${range.first?.toRelativeDayFormatted()} - ${range.last?.toRelativeDayFormatted()}';
        }
      },
    );
  }
}
