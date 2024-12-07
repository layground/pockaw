import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';

class MyGoalsCarousel extends StatelessWidget {
  const MyGoalsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Goals',
                style: AppTextStyles.heading6,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing12,
                  vertical: AppSpacing.spacing4,
                ),
                decoration: ShapeDecoration(
                  color: AppColors.secondary100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                  ),
                ),
                child: Text(
                  '2 of 3',
                  style: AppTextStyles.body4.copyWith(
                    color: AppColors.primary700,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing16),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacing12),
            decoration: ShapeDecoration(
              color: AppColors.primary100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                    Icon(
                      TablerIcons.chevron_left,
                      color: AppColors.primary300,
                      size: 20,
                    ),
                    Text(
                      'Build my dream PC',
                      style: AppTextStyles.body3,
                    ),
                    Icon(
                      TablerIcons.chevron_right,
                      color: AppColors.primary300,
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
                        color: AppColors.primary200,
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
                          AppColors.secondary,
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
                              Icon(
                                TablerIcons.circle_check,
                                color: AppColors.primary400,
                                size: 20,
                              ),
                              Gap(AppSpacing.spacing4),
                              Text(
                                'Buy i9 or Ryzen7 processor',
                                style: AppTextStyles.body4.copyWith(
                                  color: AppColors.primary400,
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
                                color: AppColors.primary700,
                                size: 20,
                              ),
                              Gap(AppSpacing.spacing4),
                              Text(
                                'Buy NVIDIA graphic card',
                                style: AppTextStyles.body4.copyWith(
                                  color: AppColors.primary700,
                                ),
                              ),
                            ],
                          ),
                          const Gap(AppSpacing.spacing8),
                          Text(
                            'Tap to view more',
                            style: AppTextStyles.body5.copyWith(
                              color: AppColors.primary800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
