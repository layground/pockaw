part of '../screens/login_screen.dart';

class Form extends StatelessWidget {
  const Form({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get Started',
                style: AppTextStyles.heading5,
              ),
              Gap(AppSpacing.spacing4),
              Text.rich(
                style: AppTextStyles.body3,
                TextSpan(
                  text: 'Please enter your ',
                  children: [
                    TextSpan(
                      text: 'name or brand name',
                      style: TextStyle(
                          fontVariations: [FontVariation.weight(700)]),
                    ),
                    TextSpan(
                      text: ', pick your best ',
                    ),
                    TextSpan(
                      text: 'picture',
                      style: TextStyle(
                          fontVariations: [FontVariation.weight(700)]),
                    ),
                    TextSpan(
                      text: ' and choose your ',
                    ),
                    TextSpan(
                      text: 'currency',
                      style: TextStyle(
                          fontVariations: [FontVariation.weight(700)]),
                    ),
                    TextSpan(
                      text: ' to personalize your account.',
                    ),
                  ],
                ),
              )
            ],
          ),
          const Gap(AppSpacing.spacing20),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Name',
                      hint: 'John Doe',
                      prefixIcon: TablerIcons.letter_case,
                    ),
                  ),
                  const Gap(AppSpacing.spacing16),
                  InkWell(
                    child: Container(
                      height: 72,
                      width: 72,
                      padding: const EdgeInsets.all(AppSpacing.spacing20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.radius8),
                        color: AppColors.light,
                        border: Border.all(
                          color: AppColors.neutralAlpha50,
                        ),
                      ),
                      child: const Icon(TablerIcons.photo),
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.spacing16),
              const CurrencyPickerField(),
            ],
          ),
          const Gap(AppSpacing.spacing20),
          Text.rich(
            TextSpan(
                text: 'We only store your data into local database '
                    'on this device. So you are in charge! ',
                style: AppTextStyles.body4,
                children: [
                  TextSpan(
                    text: 'Read more.',
                    style: AppTextStyles.body4.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.secondary,
                      color: AppColors.secondary,
                    ),
                  ),
                ]),
          ),
          const Gap(AppSpacing.spacing56),
        ],
      ),
    );
  }
}
