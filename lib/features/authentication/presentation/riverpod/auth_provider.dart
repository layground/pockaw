import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/authentication/data/repositories/user_repository.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  UserModel build() {
    return UserRepository.dummy;
  }

  void setUser(UserModel user) {
    state = user;
    Log.d(state.toJson(), label: 'existing user state');
    _setSession();
  }

  Future<void> setImage(String? imagePath) async {
    state = state.copyWith(profilePicture: imagePath);
    await _setSession();
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

  Future<UserModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    // get user from preferences and convert to UserModel
    final userString = prefs.getString('user');
    UserModel? userModel;

    if (userString != null) {
      final userJson = jsonDecode(userString);
      userModel = UserModel.fromJson(userJson);
      Log.i(userModel.toJson(), label: 'user session from prefs');
    }

    final userDao = ref.read(userDaoProvider);
    final userFromDb = await userDao.getUserByEmail(userModel?.email ?? '');
    if (userFromDb != null) {
      final userModel = userFromDb.toModel();
      state = userModel;
      Log.i(userModel.toJson(), label: 'user session from db');
      return userModel;
    }

    Log.i(null, label: 'no user session in db');
    return null;
  }

  Future<void> deleteUser() async {
    final userDao = ref.read(userDaoProvider);
    await userDao.deleteAllUsers();
  }

  Future<void> clearDatabase() async {
    final db = ref.read(databaseProvider);
    await db.clearAllTables();
    await db.populateCategories();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    // reset all providers
    ref.read(activeWalletProvider.notifier).reset();

    state = UserRepository.dummy;
  }

  /// Delete data
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
