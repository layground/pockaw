import 'package:drift/drift.dart';
import 'package:pockaw/core/database/pockaw_database.dart';
import 'package:pockaw/core/database/tables/users.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<User?> getFirstUser() => select(users).getSingleOrNull();

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);

  Future<void> deleteAllUsers() => delete(users).go();
}

/// Converts a database [User] object to a [UserModel].
extension UserDataToModel on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      profilePicture: profilePicture,
      isPremium: isPremium,
      createdAt: createdAt,
    );
  }
}

/// Converts a [UserModel] to a database-compatible [UsersCompanion].
extension UserModelToCompanion on UserModel {
  UsersCompanion toCompanion() {
    return UsersCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      name: Value(name),
      email: Value(email),
      password: Value(password),
      profilePicture: Value(profilePicture),
      isPremium: Value(isPremium),
      createdAt: Value(createdAt ?? DateTime.now()),
    );
  }
}
