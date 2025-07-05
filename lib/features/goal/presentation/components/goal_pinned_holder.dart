import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/goal/presentation/components/goal_card.dart';
import 'package:pockaw/features/goal/presentation/riverpod/goals_list_provider.dart';

class GoalPinnedHolder extends ConsumerWidget {
  const GoalPinnedHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGoals = ref.watch(
      pinnedGoalsProvider,
    ); // <-- Use pinnedGoalsProvider

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pinned Goals', style: AppTextStyles.heading6),
          const Gap(AppSpacing.spacing16),
          asyncGoals.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(
                  child: Text('No goals pinned.', style: AppTextStyles.body3),
                );
              }

              return SizedBox(
                height: 150,
                child: ListView.separated(
                  itemCount: data.take(5).length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AspectRatio(
                      aspectRatio: 6 / 3,
                      child: GoalCard(goal: data[index]),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Gap(AppSpacing.spacing12),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) =>
                Center(child: Text('Error: $e', style: AppTextStyles.body3)),
          ),
        ],
      ),
    );
  }
}
