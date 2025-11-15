import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/google/google_auth_service.dart';
import 'package:pockaw/core/services/keyboard_service/virtual_keyboard_service.dart';
import 'package:pockaw/core/utils/locale_utils.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/authentication/data/repositories/user_repository.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:pockaw/features/user_activity/data/enum/user_activity_action.dart';
import 'package:pockaw/features/user_activity/riverpod/user_activity_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

// Provider for the UserDao
final userDaoProvider = Provider<UserDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.userDao;
});

final authProvider = FutureProvider<UserModel?>((ref) async {
  return await ref.read(authStateProvider.notifier).getSession();
});

/// Migrated from StateNotifier to Notifier (Riverpod 3 pattern)
class AuthNotifier extends Notifier<UserModel> {
  bool isLoading = false;

  @override
  UserModel build() {
    return UserRepository.dummy;
  }

  Future<void> setUser(UserModel user) async {
    state = user;
    Log.d(state.toJson(), label: 'existing user state');
    await _setSession();
  }

  Future<void> setImage(String? imagePath) async {
    state = state.copyWith(profilePicture: imagePath);
    await _setSession();
  }

  Future<void> signInWithGoogle({
    required BuildContext context,
  }) async {
    KeyboardService.closeKeyboard();

    ref
        .read(googleAuthProvider.notifier)
        .signIn(
          onSuccess: (account) async {
            if (account != null && context.mounted) {
              Log.d('proceed', label: 'google signin');

              signInOrRegister(
                context: context,
                username: account.displayName ?? 'User',
                email: account.email,
                profilePicture: account.photoUrl,
              );
            }
          },
          onError: () {
            if (context.mounted) {
              Log.d('error', label: 'google signin');
              Toast.show(
                'Google Sign-In is not supported on this platform.',
                type: ToastificationType.error,
              );
            }
          },
        );
  }

  Future<void> startJourney({
    required BuildContext context,
    required String username,
    String? email,
    String? profilePicture,
  }) async {
    KeyboardService.closeKeyboard();
    isLoading = true;

    await signInOrRegister(
      context: context,
      username: username,
      email: email,
      profilePicture: profilePicture,
    );

    isLoading = false;
  }

  /// Initiates the user journey process
  ///
  /// Validates the username, creates a user profile, saves it, and navigates to main screen.
  /// Uses AsyncNotifier state to represent loading / error / data states.
  Future<void> signInOrRegister({
    required BuildContext context,
    required String username,
    String? email,
    String? profilePicture,
  }) async {
    try {
      KeyboardService.closeKeyboard();

      // Validate username
      if (username.trim().isEmpty) {
        if (context.mounted) {
          Toast.show(
            'Please enter a name.',
            type: ToastificationType.error,
          );
        }
        return;
      }

      String userEmail =
          email ??
          '${username.trim().toLowerCase().replaceAll(' ', '_')}@mail.com';

      state = UserModel(
        name: username.trim(),
        email: userEmail,
        profilePicture: profilePicture,
        createdAt: DateTime.now(),
      );

      // Find existing user
      final db = ref.read(databaseProvider);
      await getSession(userEmail);
      bool userExists = state.id != null;
      Log.d('User exists: ${state.id}', label: 'sign in or register');

      if (userExists) {
        await _setSession();
        // find wallet by user id and set active wallet
        final wallet = await db.walletDao.getWalletByUserId(state.id ?? 0);
        if (wallet != null) {
          ref
              .read(activeWalletProvider.notifier)
              .setActiveWalletByID(wallet.id);
        }

        ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.signIn);
      } else {
        await _setSession();
        final currencyNotifier = ref.read(currenciesStaticProvider.notifier);
        final deviceRegion = await getDeviceRegion();
        final selectedCurrency = currencyNotifier.getCurrencyByISOCode(
          deviceRegion,
        );

        Log.d(selectedCurrency.toJson(), label: 'selected currency');
        ref.read(currencyProvider.notifier).setCurrency(selectedCurrency);

        final wallet = WalletModel(
          userId: state.id,
          currency: selectedCurrency.isoCode,
        );
        int walletID = await db.walletDao.addWallet(wallet);
        Log.d(wallet.toJson(), label: 'selected wallet');
        ref.read(activeWalletProvider.notifier).setActiveWalletByID(walletID);

        ref
            .read(userActivityServiceProvider)
            .logActivity(action: UserActivityAction.journeyStarted);
      }

      // Navigate to main screen
      if (context.mounted) {
        context.push(Routes.main);
      }
    } catch (e, stackTrace) {
      Log.e(stackTrace.toString(), label: 'sign in or register');
      if (context.mounted) {
        Toast.show(
          'An error occurred. Please try again.',
          type: ToastificationType.error,
        );
      }
    }
  }

  UserModel getUser() => state;

  Future<void> _setSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userDao = ref.read(userDaoProvider);
    final existingUser = await userDao.getUserByEmail(state.email);
    Log.d(existingUser?.toJson(), label: 'existing user');

    if (existingUser != null) {
      // Update the user, ensuring the ID from the database is preserved
      await userDao.updateUser(
        state.copyWith(id: existingUser.id).toCompanion(),
      );
      Log.i(state.toJson(), label: 'updated user session');
    } else {
      // Insert a new user
      final newId = await userDao.insertUser(state.toCompanion());
      state = state.copyWith(id: newId); // Update state with the new ID from DB
      Log.i(state.toJson(), label: 'created user session');
    }

    prefs.setString('user', jsonEncode(state.toJson()));
  }

  Future<UserModel?> getSession([String? email]) async {
    final prefs = await SharedPreferences.getInstance();
    // get user from preferences and convert to UserModel
    final userString = prefs.getString('user');
    UserModel? userModel;

    if (userString != null) {
      final userJson = jsonDecode(userString);
      userModel = UserModel.fromJson(userJson);
      Log.i(userModel.toJson(), label: 'user session from prefs');
    }

    await selectDefaultCurrency();

    final userDao = ref.read(userDaoProvider);
    final userFromDb = await userDao.getUserByEmail(
      userModel?.email ?? email ?? '',
    );
    if (userFromDb != null) {
      userModel = userFromDb.toModel();
      state = userModel;
      Log.i(userModel.toJson(), label: 'user session from db');
      return userModel;
    }

    Log.i(null, label: 'no user session in db');
    return null;
  }

  Future<void> selectDefaultCurrency() async {
    try {
      final currencyList = await ref.read(currenciesProvider.future);
      ref.read(currenciesStaticProvider.notifier).setCurrencies(currencyList);
      Log.d(currencyList.length, label: 'currencies populated');
    } catch (e) {
      Log.e(
        'Failed to load currencies for static provider',
        label: 'currencies',
      );
    }
  }

  Future<void> deleteUser() async {
    final userDao = ref.read(userDaoProvider);
    await userDao.deleteAllUsers();
  }

  Future<void> clearDatabase() async {
    final db = ref.read(databaseProvider);
    await db.clearAllTables();
    await db.populateCategories();

    await ref
        .read(userActivityServiceProvider)
        .logActivity(action: UserActivityAction.databaseCleared);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    await ref
        .read(userActivityServiceProvider)
        .logActivity(action: UserActivityAction.signOut);

    // reset all providers
    ref.read(activeWalletProvider.notifier).reset();

    final googleAccount = ref.read(googleAuthProvider.notifier);
    googleAccount.signOut();

    state = UserRepository.dummy;
  }

  Future<void> deleteData() async {
    // reset all providers
    ref.read(activeWalletProvider.notifier).reset();

    await logout();
    await deleteUser();
    await clearDatabase();
  }
}

/// Replace StateNotifierProvider with NotifierProvider
final authStateProvider = NotifierProvider<AuthNotifier, UserModel>(
  AuthNotifier.new,
);
