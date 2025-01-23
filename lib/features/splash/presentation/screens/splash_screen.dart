import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/router/app_router.dart';
import 'package:pockaw/core/router/routes.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.read(authProvider.future).then(
      (hasSession) {
        if (!hasSession) {
          GoRouter.of(rootNavKey.currentContext!).go(Routes.onboarding);
        } else {
          GoRouter.of(rootNavKey.currentContext!).go(Routes.main);
        }
      },
    );

    return const Scaffold(
      backgroundColor: AppColors.primary50,
      body: Center(
        child: Text('Splash'),
      ),
    );
  }
}
