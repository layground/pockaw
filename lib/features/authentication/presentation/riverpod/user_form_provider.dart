import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/features/authentication/data/repositories/user_repository.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';

final userProvider = StateProvider<UserModel>((ref) {
  return UserRepository.dummy;
});
