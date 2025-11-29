part of '../screens/goal_details_screen.dart';

class GoalChecklist extends StatelessWidget {
  final List<ChecklistItemModel> items;
  const GoalChecklist({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No checklist items.'));
    }
    return ListView.separated(
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => GoalChecklistItem(item: items[index]),
      separatorBuilder: (context, index) => const Gap(AppSpacing.spacing8),
    );
  }
}
