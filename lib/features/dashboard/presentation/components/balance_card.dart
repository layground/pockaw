part of '../screens/dashboard_screen.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.secondary50,
        borderRadius: BorderRadius.circular(AppRadius.radius16),
        border: Border.all(color: AppColors.secondaryAlpha10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Balance',
            style: AppTextStyles.body3.copyWith(color: AppColors.neutral800),
          ),
          const Gap(AppSpacing.spacing8),
          const WalletSwitcherDropdown(),
          const Gap(AppSpacing.spacing8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp.',
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                '791.235.401',
                style: AppTextStyles.numericHeading.copyWith(
                  color: AppColors.secondary950,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
