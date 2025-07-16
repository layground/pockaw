import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/theme_switcher/presentation/components/theme_mode_switcher.dart';

part '../components/get_started_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      showBackButton: false,
      showBalance: false,
      actions: [ThemeModeSwitcher()],
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            // color: Colors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon/icon-transparent-full.png',
                  width: 160,
                ),
                const Gap(16),
                const Text(
                  'Welcome to',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Pockaw!',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                Text(
                  'Simple and intuitive finance buddy. Track your expenses, set goals, '
                  'organize your pocket and wallet sized finance — everything effortlessly. 🚀',
                  style: AppTextStyles.body1.copyWith(
                    fontVariations: [const FontVariation.weight(500)],
                  ),
                  textAlign: TextAlign.center,
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
