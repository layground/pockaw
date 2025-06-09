part of 'custom_scaffold.dart';

class BalanceStatusBar extends PreferredSize {
  BalanceStatusBar({super.key})
      : super(
          preferredSize: const Size.fromHeight(35),
          child: Container(
            height: 35,
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              0,
              AppSpacing.spacing20,
              0,
            ),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppColors.purple50,
              border: Border.all(color: AppColors.purpleAlpha10),
              borderRadius: BorderRadius.circular(AppRadius.radius8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        HugeIcons.strokeRoundedWallet01,
                        size: 16,
                        color: AppColors.purple,
                      ),
                      const Gap(2),
                      Text(
                        'E-Wallet',
                        style: AppTextStyles.body4.copyWith(
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.spacing8),
                Expanded(
                  child: Text(
                    'Rp. 589.234',
                    style: AppTextStyles.numericRegular.bold,
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
        );
}
