import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';

part '../components/get_started_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                Image.asset(
                  'assets/icon/icon-transparent-full.png',
                  width: 160,
                ),
                const Gap(16),
                const Text(
                  'Welcome to',
                  style: AppTextStyles.heading2,
                ),
                const Text(
                  'Pockaw!',
                  style: AppTextStyles.heading2,
                ),
                const Gap(16),
                Text(
                  'Simple and intuitive finance buddy. Track your expenses, set goals, '
                  'organize your pocket and wallet sized finance — everything effortlessly. 🚀',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.neutral800,
                    fontVariations: [const FontVariation.weight(500)],
                  ),
                ),
                const Gap(150),
              ],
            ),
          ),
          const GetStartedButton(),
        ],
      ),
    );
  }
}
