import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/services/url_launcher/url_launcher.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      showBalance: false,
      title: 'Coming Soon',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.spacing12,
        children: [
          Center(
            child: LottieBuilder.asset(
              'assets/lottie/coming_soon.json',
              width: 200,
            ),
          ),
          Text('Coming Soon', style: AppTextStyles.heading3),
          Text.rich(
            TextSpan(
              text: 'Lottie animation by ',
              style: AppTextStyles.body4,
              children: [
                TextSpan(
                  text: 'Febri Prastyo',
                  style: AppTextStyles.body4.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: context.secondaryText,
                    color: context.secondaryText,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      LinkLauncher.launch(
                        'https://lottiefiles.com/free-animation/under-construction-I1T7555ZQG',
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
