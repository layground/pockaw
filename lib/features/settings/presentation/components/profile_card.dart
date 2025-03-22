part of '../screens/settings_screen.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.darkAlpha10,
            radius: 50,
            child: CircleAvatar(
              backgroundColor: AppColors.tertiary800,
              radius: 49,
            ),
          ),
          const Gap(AppSpacing.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenny Wilson',
                style: AppTextStyles.body1,
              ),
              Text(
                'The Clever Squirrel',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.darkAlpha50,
                ),
              ),
              const Gap(AppSpacing.spacing8),
              const CustomCurrencyChip(
                countryCode: 'US',
                label: 'USD (\$)',
                background: AppColors.primaryAlpha10,
                foreground: AppColors.dark,
                borderColor: AppColors.primaryAlpha25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
