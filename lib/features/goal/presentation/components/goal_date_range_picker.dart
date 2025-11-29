part of '../screens/goal_form_dialog.dart';

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
      context: context,
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
          selectedDateNotifier.setRange(dateRange);
          updateDate();
        }
      },
    );
  }
}
