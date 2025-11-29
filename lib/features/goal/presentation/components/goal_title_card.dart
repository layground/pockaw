part of '../screens/goal_details_screen.dart';

class GoalTitleCard extends ConsumerWidget {
  final GoalModel goal;
  const GoalTitleCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context, ref) {
    final goalDescription = goal.description ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      decoration: BoxDecoration(
        border: Border.all(color: context.purpleBorder),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${goal.startDate?.toDayShortMonthYear()} - ${goal.endDate.toDayShortMonthYear()}',
            style: AppTextStyles.body5,
          ),
          Gap(AppSpacing.spacing8),
          Text(goal.title, style: AppTextStyles.body2),
          Text(
            goalDescription.isEmpty
                ? 'No description available.'
                : goal.description!,
            style: AppTextStyles.body4.copyWith(
              fontStyle: goalDescription.isEmpty ? FontStyle.italic : null,
            ),
          ),
        ],
      ),
    );
  }
}
