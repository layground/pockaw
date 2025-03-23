import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/date_picker_provider.dart';

class TransactionDatePicker extends HookConsumerWidget {
  const TransactionDatePicker({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedDate = ref.watch(datePickerProvider);
    final selectedDateNotifier = ref.read(datePickerProvider.notifier);
    final dateFieldController = useTextEditingController();

    return CustomSelectField(
      controller: dateFieldController,
      label: 'Set a date',
      hint: '12 November 2024',
      prefixIcon: TablerIcons.calendar,
      isRequired: true,
      onTap: () async {
        var dates = await showCalendarDatePicker2Dialog(
          context: context,
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.single,
            lastDate: DateTime.now(),
            dayTextStyle: AppTextStyles.body4,
            selectedDayTextStyle: AppTextStyles.body4.copyWith(
              color: AppColors.light,
            ),
            monthTextStyle: AppTextStyles.body4,
            selectedMonthTextStyle: AppTextStyles.body4.copyWith(
              color: AppColors.light,
            ),
            yearTextStyle: AppTextStyles.body4,
            selectedYearTextStyle: AppTextStyles.body4.copyWith(
              color: AppColors.light,
            ),
            weekdayLabelTextStyle: AppTextStyles.body4,
            todayTextStyle: AppTextStyles.body4.copyWith(
              color: AppColors.primary,
            ),
          ),
          dialogSize: const Size(325, 400),
          value: selectedDate,
          borderRadius: BorderRadius.circular(15),
        );

        if (dates != null && dates.first != null) {
          selectedDateNotifier.state = dates;
          final selectedDateTime = selectedDate.first!.add(Duration(
            hours: DateTime.now().hour,
            minutes: DateTime.now().minute,
            seconds: DateTime.now().second,
          ));

          Log.e(selectedDateTime, label: 'selected date');
          dateFieldController.text =
              selectedDateTime.toDayMonthYearTime12Hour();
        }
      },
    );
  }
}
