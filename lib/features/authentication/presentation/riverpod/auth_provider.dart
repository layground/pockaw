import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/authentication/data/repositories/user_repository.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';

// Provider for the UserDao
final userDaoProvider = Provider<UserDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.userDao;
});

final authProvider = FutureProvider<UserModel?>((ref) async {
  return await ref.read(authStateProvider.notifier).getSession();
});

class AuthProvider extends StateNotifier<UserModel> {
  final Ref ref;
  AuthProvider(this.ref) : super(UserRepository.dummy);

  void setUser(UserModel user) {
    state = user;
    _setSession();
  }

  Future<void> setImage(String? imagePath) async {
    state = state.copyWith(profilePicture: imagePath);
    await _setSession();
  }

  UserModel getUser() => state;

  Future<void> _setSession() async {
    final userDao = ref.read(userDaoProvider);
    final existingUser = await userDao.getFirstUser();

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
  }

  Future<UserModel?> getSession() async {
    final userDao = ref.read(userDaoProvider);
    final userFromDb = await userDao.getFirstUser();
    if (userFromDb != null) {
      final userModel = userFromDb.toModel();
      state = userModel;
      Log.i(userModel.toJson(), label: 'user session from db');
      return userModel;
    }

    Log.i(null, label: 'no user session in db');
    return null;
  }

  Future<void> logout() async {
    final userDao = ref.read(userDaoProvider);
    await userDao.deleteAllUsers();
    state = UserRepository.dummy;
  }
}

final authStateProvider = StateNotifierProvider<AuthProvider, UserModel>((ref) {
  return AuthProvider(ref);
});
