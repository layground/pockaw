import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final dateFieldController = useTextEditingController(
        text: initialDate?.toDayMonthYearTime12Hour() ?? '');

    return CustomSelectField(
      controller: dateFieldController,
      label: 'Set a date',
      hint: '12 November 2024',
      prefixIcon: TablerIcons.calendar,
      isRequired: true,
      onTap: () async {
        var date =
            await CustomDatePicker.selectSingleDate(context, selectedDate);

        if (date != null) {
          final selectedDateTime = date.add(Duration(
            hours: DateTime.now().hour,
            minutes: DateTime.now().minute,
            seconds: DateTime.now().second,
          ));

          selectedDateNotifier.state = selectedDateTime;

          Log.e(selectedDateTime, label: 'selected date');
          dateFieldController.text =
              selectedDateTime.toDayMonthYearTime12Hour();
        } else if (initialDate != null) {
          selectedDateNotifier.state = initialDate!;
          dateFieldController.text = initialDate!.toDayMonthYearTime12Hour();
        }
      },
    );
  }
}
