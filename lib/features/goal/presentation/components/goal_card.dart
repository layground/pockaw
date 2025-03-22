import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.goalDetails),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: AppColors.purple50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.purpleAlpha10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Build my dream PC',
                  style: AppTextStyles.body3,
                ),
                Icon(
                  TablerIcons.chevron_right,
                  color: AppColors.purple,
                  size: 20,
                ),
              ],
            ),
            const Gap(AppSpacing.spacing16),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  padding: const EdgeInsets.all(AppSpacing.spacing4),
                  decoration: ShapeDecoration(
                    color: AppColors.purpleAlpha10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppRadius.radiusFull,
                      ),
                    ),
                  ),
                  child: LinearProgressIndicator(
                    value: 0.76,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.purple,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppRadius.radiusFull,
                    ),
                  ),
                ),
                const Gap(AppSpacing.spacing8),
                Container(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            TablerIcons.circle_check,
                            color: AppColors.neutralAlpha50,
                            size: 20,
                          ),
                          const Gap(AppSpacing.spacing4),
                          Text(
                            'Buy i9 or Ryzen7 processor',
                            style: AppTextStyles.body4.copyWith(
                              color: AppColors.neutralAlpha50,
                            ),
                          ),
                        ],
                      ),
                      const Gap(AppSpacing.spacing4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            TablerIcons.circle,
                            color: AppColors.purple900,
                            size: 20,
                          ),
                          const Gap(AppSpacing.spacing4),
                          Text(
                            'Buy NVIDIA graphic card',
                            style: AppTextStyles.body4.copyWith(
                              color: AppColors.purple900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
