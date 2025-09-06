import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:pockaw/core/components/date_picker/date_time_picker_dialog.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/utils/logger.dart';

class CustomDatePicker {
  static final _datePickerConfig = CalendarDatePicker2WithActionButtonsConfig(
    calendarType: CalendarDatePicker2Type.single,
    lastDate: DateTime.now(),
    dayTextStyle: AppTextStyles.body4,
    selectedDayTextStyle: AppTextStyles.body4.copyWith(color: AppColors.light),
    monthTextStyle: AppTextStyles.body4,
    selectedMonthTextStyle: AppTextStyles.body4.copyWith(
      color: AppColors.light,
    ),
    yearTextStyle: AppTextStyles.body4,
    selectedYearTextStyle: AppTextStyles.body4.copyWith(color: AppColors.light),
    weekdayLabelTextStyle: AppTextStyles.body4,
    todayTextStyle: AppTextStyles.body4.copyWith(color: AppColors.primary),
  );

  static Future<DateTime?> selectSingleDate(
    BuildContext context, {
    required String title,
    DateTime? selectedDate,
    ValueChanged<DateTime>? onDateTimeChanged,
    ValueChanged<DateTime>? onDateSelected,
  }) async {
    return await context.openBottomSheet<DateTime?>(
      child: DateTimePickerDialog(
        title: title,
        initialdate: selectedDate,
        onDateSelected: onDateSelected,
        onDateTimeChanged: onDateTimeChanged,
      ),
    );
  }

  static Future<List<DateTime?>?> selectDateRange(
    BuildContext context,
    List<DateTime?> selectedDateRange, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    var dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: _datePickerConfig.copyWith(
        calendarType: CalendarDatePicker2Type.range,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
      dialogSize: const Size(325, 400),
      value: selectedDateRange,
      borderRadius: BorderRadius.circular(15),
    );

    if (dates != null) {
      final duration = Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
      );

      DateTime? selectedStartDate;
      DateTime? selectedEndDate;

      if (dates.first != null) {
        selectedStartDate = dates.first!.add(duration);
      }

      if (dates.last != null) {
        selectedEndDate = dates.last!.add(duration);
      }

      Log.d([selectedStartDate, selectedEndDate], label: 'selected date range');
      return [selectedStartDate, selectedEndDate];
    }

    return null;
  }
}
