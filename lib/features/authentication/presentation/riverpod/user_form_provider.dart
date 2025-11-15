import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/keyboard_service/virtual_keyboard_service.dart';
import 'package:pockaw/core/utils/locale_utils.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:pockaw/features/user_activity/data/enum/user_activity_action.dart';
import 'package:pockaw/features/user_activity/riverpod/user_activity_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

// Start journey notifier that handles the complete flow
class StartJourneyNotifier extends AsyncNotifier<void> {
  @override
  void build() {}

  /// Initiates the user journey process
  ///
  /// Validates the username, creates a user profile, saves it, and navigates to main screen.
  /// Uses AsyncNotifier state to represent loading / error / data states.
  Future<void> startJourney({
    required BuildContext context,
    required String username,
    String? email,
    String? profilePicture,
  }) async {
    // Start loading
    state = const AsyncValue.loading();

    try {
      KeyboardService.closeKeyboard();

      // Validate username
      if (username.trim().isEmpty) {
        if (context.mounted) {
          toastification.show(
            description: Text(
              'Please enter a name.',
              style: AppTextStyles.body2,
            ),
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
          );
        }

        state = const AsyncValue.data(null);
        return;
      }

      UserModel user;

      // Find existing user
      final userDao = ref.read(userDaoProvider);
      final existingUser = await userDao.getUserByEmail(
        '${username.replaceAll(' ', '').toLowerCase()}@mail.com',
      );
      Log.d(existingUser?.toJson(), label: 'existing user');

      if (existingUser != null) {
        user = existingUser.toModel();

        // find wallet by user id and set active wallet
        final db = ref.read(databaseProvider);
        final wallet = await db.walletDao.getWalletByUserId(user.id!);
        if (wallet != null) {
          ref
              .read(activeWalletProvider.notifier)
              .setActiveWalletByID(wallet.id);
        }
      } else {
        // Create user model
        user = UserModel(
          name: username.trim(),
          email:
              email ?? '${username.replaceAll(' ', '').toLowerCase()}@mail.com',
          profilePicture: profilePicture,
          createdAt: DateTime.now(),
        );

        final currencyNotifier = ref.read(currenciesStaticProvider.notifier);
        final deviceRegion = await getDeviceRegion();
        final selectedCurrency = currencyNotifier.getCurrencyByISOCode(
          deviceRegion,
        );
        Log.d(selectedCurrency.toJson(), label: 'selected currency');
        ref.read(currencyProvider.notifier).setCurrency(selectedCurrency);

        final wallet = WalletModel(
          userId: user.id,
          currency: selectedCurrency.isoCode,
        );
        final db = ref.read(databaseProvider);
        int walletID = await db.walletDao.addWallet(wallet);
        Log.d(wallet.toJson(), label: 'selected wallet');
        ref.read(activeWalletProvider.notifier).setActiveWalletByID(walletID);
      }

      // Save user to auth state
      ref.read(authStateProvider.notifier).setUser(user);

      /// log user journey started
      await ref
          .read(userActivityServiceProvider)
          .logActivity(action: UserActivityAction.journeyStarted);

      // Navigate to main screen
      if (context.mounted) {
        context.push(Routes.main);
      }

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);

      if (context.mounted) {
        toastification.show(
          description: Text(
            'An error occurred. Please try again.',
            style: AppTextStyles.body2,
          ),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }
}

final startJourneyProvider = AsyncNotifierProvider<StartJourneyNotifier, void>(
  StartJourneyNotifier.new,
);
