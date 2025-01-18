import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57,
      child: Row(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary100,
                    borderRadius: BorderRadius.circular(
                      AppRadius.radius12,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      TablerIcons.headphones,
                      size: 24,
                      color: AppColors.secondary950,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '09 December',
                  style: AppTextStyles.body5.copyWith(
                    color: AppColors.primary700,
                  ),
                ),
                Text(
                  'Rp. 1.120.300',
                  style: AppTextStyles.numericLarge.copyWith(
                    color: AppColors.secondary900,
                    height: 1.12,
                  ),
                ),
                const Text(
                  'Web maintenance',
                  style: AppTextStyles.body4,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
