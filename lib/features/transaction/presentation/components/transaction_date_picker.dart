import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/date_picker/custom_date_picker.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart';

class TransactionDatePicker extends ConsumerWidget {
  final DateTime? initialDate;
  final TextEditingController dateFieldController;
  const TransactionDatePicker({
    super.key,
    required this.dateFieldController,
    this.initialDate,
  });

  @override
  Widget build(BuildContext context, ref) {
    final selectedDateNotifier = ref.read(datePickerProvider.notifier);
    dateFieldController.text = (initialDate ?? DateTime.now())
        .toRelativeDayFormatted(showTime: true, use24Hours: false);

    return CustomSelectField(
      context: context,
      controller: dateFieldController,
      label: 'Set a date',
      hint: DateTime.now().toRelativeDayFormatted(
        showTime: true,
        use24Hours: false,
      ),
      prefixIcon: HugeIcons.strokeRoundedCalendar01,
      isRequired: true,
      onTap: () {
        selectedDateNotifier.setDate(initialDate ?? DateTime.now());

        CustomDatePicker.selectSingleDate(
          context,
          title: 'Transaction Date & Time',
          selectedDate: initialDate ?? DateTime.now(),
          onDateTimeChanged: (date) {
            selectedDateNotifier.setDate(date);
            Log.d(date, label: 'selected date');
            dateFieldController.text = date.toRelativeDayFormatted(
              showTime: true,
              use24Hours: false,
            );
          },
        );
      },
    );
  }
}
