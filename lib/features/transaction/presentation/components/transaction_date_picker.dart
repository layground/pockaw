import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/date_picker/custom_date_picker.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart';

class TransactionDatePicker extends HookConsumerWidget {
  final DateTime? initialDate;
  const TransactionDatePicker({super.key, this.initialDate});

  @override
  Widget build(BuildContext context, ref) {
    final selectedDate = ref.watch(datePickerProvider);
    final selectedDateNotifier = ref.read(datePickerProvider.notifier);
    final dateFieldController = useTextEditingController();

    useEffect(() {
      dateFieldController.text =
          initialDate?.toDayMonthYearTime12Hour() ??
          selectedDate.toDayMonthYearTime12Hour();
      return null;
    }, []);

    return CustomSelectField(
      controller: dateFieldController,
      label: 'Set a date',
      hint: '12 November 2024 08.00 AM',
      prefixIcon: HugeIcons.strokeRoundedCalendar01,
      isRequired: true,
      onTap: () async {
        var date = await CustomDatePicker.selectSingleDate(
          context,
          selectedDate,
        );

        if (date != null) {
          selectedDateNotifier.state = date;
          Log.d(date, label: 'selected date');
          dateFieldController.text = date.toDayMonthYearTime12Hour();
        }
      },
    );
  }
}
