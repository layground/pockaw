import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/router/app_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.read(authStateProvider.notifier);
    auth.getSession().then((user) {
      // Initialize database and populate data
      final db = ref.read(databaseProvider);
      Log.d(db.schemaVersion, label: 'schema version');

      if (user == null) {
        GoRouter.of(rootNavKey.currentContext!).go(Routes.onboarding);
      } else {
        GoRouter.of(rootNavKey.currentContext!).go(Routes.main);
      }
    });

    return const Scaffold(
      backgroundColor: AppColors.primary50,
      body: Center(child: Text('Splash')),
    );
  }
}
