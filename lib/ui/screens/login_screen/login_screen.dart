import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/config/app_router.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';
import 'package:pockaw/ui/widgets/buttons/buttons.dart';
import 'package:pockaw/ui/widgets/buttons/circle_button.dart';
import 'package:pockaw/ui/widgets/text_fields/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            // color: Colors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/icon-transparent-full.png',
                        width: 100,
                      ),
                      const Gap(AppSpacing.spacing12),
                      const Text(
                        'Pockaw',
                        style: TextStyle(
                          fontSize: 38,
                          fontVariations: [FontVariation.weight(900)],
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.spacing48),
                Column(
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: AppTextStyles.heading4,
                        ),
                        Gap(AppSpacing.spacing4),
                        Text(
                          'Please enter your nickname and pick your best picture to personalize your account.',
                          style: AppTextStyles.body3,
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.spacing20),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: CustomTextField(
                                label: 'Nickname',
                                hint: 'Enter your nickname...',
                                icon: TablerIcons.letter_case,
                              ),
                            ),
                            const Gap(AppSpacing.spacing16),
                            Container(
                              padding:
                                  const EdgeInsets.all(AppSpacing.spacing4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary100,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.radius8,
                                ),
                              ),
                              child: DottedBorder(
                                borderType: BorderType.Circle,
                                strokeCap: StrokeCap.round,
                                dashPattern: const [8, 8],
                                color: AppColors.primary600,
                                child: const CircleIconButton(
                                  icon: TablerIcons.photo,
                                  radius: 33,
                                  backgroundColor: AppColors.secondary100,
                                  foregroundColor: AppColors.secondary800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.spacing20),
                    Text.rich(
                      TextSpan(
                          text: 'We only store your data into local database '
                              'on this device. So you are in charge! ',
                          style: AppTextStyles.body4.copyWith(
                            color: AppColors.primary600,
                          ),
                          children: [
                            TextSpan(
                              text: 'Read more.',
                              style: AppTextStyles.body4.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blueAccent,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
                const Gap(AppSpacing.spacing56),
                const Gap(AppSpacing.spacing56),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.light,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Button(
                label: 'Login',
                onPressed: () => context.push(AppRouter.home),
              ),
            ),
          )
        ],
      ),
    );
  }
}
