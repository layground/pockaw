import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';
import 'package:pockaw/ui/widgets/buttons/circle_button.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleIconButton(
          icon: TablerIcons.photo,
          radius: 25,
          backgroundColor: AppColors.secondary100,
          foregroundColor: AppColors.secondary800,
        ),
        const Gap(AppSpacing.spacing12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,',
              style: AppTextStyles.body4.copyWith(color: AppColors.primary600),
            ),
            Text(
              'Jenny',
              style: AppTextStyles.body2.copyWith(color: AppColors.primary900),
            ),
          ],
        )
      ],
    );
  }
}
