import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/router/app_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/package_info/package_info_provider.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import for useEffect

class SplashScreen extends HookConsumerWidget {
  // Changed to HookConsumerWidget
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // Use useEffect to run side effects once when the widget is built
    useEffect(() {
      Future<void> initializeApp() async {
        // Initialize database (this also triggers onCreate population services)
        final db = ref.read(databaseProvider);
        Log.d(db.schemaVersion, label: 'schema version');

        // Initialize PackageInfoService
        final packageInfoService = ref.read(packageInfoServiceProvider);
        await packageInfoService.init();

        // Delete log file
        final file = await Log.getLogFile();
        file?.delete();

        // Fetch currencies and populate the static provider
        // Using ref.read(currenciesProvider.future) to get the future directly
        try {
          final currencyList = await ref.read(currenciesProvider.future);
          ref.read(currenciesStaticProvider.notifier).state = currencyList;
          Log.d(currencyList.length, label: 'currencies populated');
        } catch (e) {
          Log.e(
            'Failed to load currencies for static provider',
            label: 'currencies',
          );
        }

        // Check user session and navigate
        final auth = ref.read(authStateProvider.notifier);
        final user = await auth.getSession();
        if (context.mounted) {
          // Ensure context is still valid
          if (user == null) {
            GoRouter.of(rootNavKey.currentContext!).go(Routes.onboarding);
          } else {
            GoRouter.of(rootNavKey.currentContext!).go(Routes.main);
          }
        }
      }

      initializeApp();
      return null; // useEffect requires a dispose function or null
    }, const []); // Empty dependency array means this runs once

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSpacing.spacing8,
          children: [
            Image.asset(
              'assets/icon/icon.png',
              width: 180,
              height: 180,
              cacheWidth: 180,
              cacheHeight: 180,
              filterQuality: FilterQuality.low,
            ),
            Text('Pockaw', style: AppTextStyles.heading3),
          ],
        ),
      ),
    );
  }
}
