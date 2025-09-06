import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

class DateTimePickerDialog extends StatelessWidget {
  final String title;
  final DateTime? initialdate;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final ValueChanged<DateTime>? onDateSelected;

  const DateTimePickerDialog({
    super.key,
    this.title = 'Select Date & Time',
    this.initialdate,
    this.onDateTimeChanged,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.spacing20,
        children: [
          CupertinoCalendar(
            mainColor: AppColors.purple,
            minimumDateTime: DateTime.now().subtract(Duration(days: 30)),
            initialDateTime: initialdate,
            maximumDateTime: DateTime.now(),
            timeLabel: 'Time',
            mode: CupertinoCalendarMode.dateTime,
            onDateTimeChanged: onDateTimeChanged,
            onDateSelected: onDateSelected,
          ),
          PrimaryButton(
            label: 'Confirm',
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
