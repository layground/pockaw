import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class DateTimePickerDialog extends StatelessWidget {
  final String title;
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final ValueChanged<DateTime>? onDateSelected;

  const DateTimePickerDialog({
    super.key,
    this.title = 'Select Date & Time',
    this.initialDate,
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
            mainColor: AppColors.primary,
            minimumDateTime: DateTime.now().subtract(Duration(days: 30)),
            initialDateTime: initialDate,
            maximumDateTime: DateTime.now(),
            timeLabel: 'Time',
            mode: CupertinoCalendarMode.dateTime,
            onDateTimeChanged: onDateTimeChanged,
            onDateSelected: onDateSelected,
            weekdayDecoration: CalendarWeekdayDecoration(
              textStyle: AppTextStyles.body3.extraBold,
            ),
            headerDecoration: CalendarHeaderDecoration(
              monthDateStyle: AppTextStyles.body3.extraBold.copyWith(
                color: AppColors.primary,
              ),
              monthDateArrowColor: AppColors.primary,
              backwardButtonColor: AppColors.primary,
              forwardButtonColor: AppColors.primary,
              backwardDisabledButtonColor: context.disabledText,
              forwardDisabledButtonColor: context.disabledText,
            ),
            footerDecoration: CalendarFooterDecoration(
              timeLabelStyle: AppTextStyles.body3.extraBold.copyWith(
                color: AppColors.primary,
              ),
              timeStyle: AppTextStyles.body3.extraBold.copyWith(
                color: AppColors.primary,
              ),
            ),
            monthPickerDecoration: CalendarMonthPickerDecoration(
              defaultDayStyle: CalendarMonthPickerDefaultDayStyle(
                textStyle: AppTextStyles.body3,
              ),
              disabledDayStyle: CalendarMonthPickerDisabledDayStyle(
                textStyle: AppTextStyles.body3.copyWith(
                  color: context.disabledText,
                ),
              ),
              selectedDayStyle: CalendarMonthPickerSelectedDayStyle(
                textStyle: AppTextStyles.body3.extraBold.copyWith(
                  color: AppColors.purple,
                ),
                backgroundCircleColor: context.purpleIcon,
              ),
              currentDayStyle: CalendarMonthPickerCurrentDayStyle(
                textStyle: AppTextStyles.body3.extraBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
              selectedCurrentDayStyle:
                  CalendarMonthPickerSelectedCurrentDayStyle(
                    textStyle: AppTextStyles.body3.extraBold.copyWith(
                      color: AppColors.purple,
                    ),
                    backgroundCircleColor: context.purpleIcon,
                  ),
            ),
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
