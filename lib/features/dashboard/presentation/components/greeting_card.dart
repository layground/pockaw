part of '../screens/dashboard_screen.dart';

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
