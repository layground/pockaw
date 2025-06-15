import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/date_picker/custom_date_picker.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/features/goal/presentation/riverpod/date_picker_provider.dart';

class GoalDateRangePicker extends HookConsumerWidget {
  final List<DateTime?>? initialDate;
  const GoalDateRangePicker({super.key, this.initialDate});

  @override
  Widget build(BuildContext context, ref) {
    final selectedDate = ref.watch(datePickerProvider);
    final selectedDateNotifier = ref.read(datePickerProvider.notifier);
    final dateFieldController = useTextEditingController();

    void updateDate() {
      final startDate = initialDate!.first ?? DateTime.now();
      final endDate =
          initialDate!.last ?? DateTime.now().add(Duration(days: 1));
      dateFieldController.text =
          '${startDate.toDayShortMonthYear()} - ${endDate.toDayShortMonthYear()}';
    }

    useEffect(() {
      if (initialDate != null) {
        updateDate();
      }

      return null;
    }, [selectedDate]);

    return CustomSelectField(
      controller: dateFieldController,
      label: 'Date to achieve goal',
      hint: '12 Nov 2024 - 12 Nov 2026',
      prefixIcon: HugeIcons.strokeRoundedCalendar01,
      isRequired: true,
      onTap: () async {
        final dateRange = await CustomDatePicker.selectDateRange(
          context,
          selectedDate,
          firstDate: DateTime.now().add(Duration(days: 1)),
          lastDate: DateTime.now().add(Duration(days: 365 * 5)),
        );

        if (dateRange != null) {
          selectedDateNotifier.state = dateRange;
          updateDate();
        }
      },
    );
  }
}
