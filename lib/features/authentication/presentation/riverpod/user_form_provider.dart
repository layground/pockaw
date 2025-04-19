import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/features/authentication/data/local/user_repository.dart';
import 'package:pockaw/features/authentication/domain/models/user_model.dart';

final userProvider = StateProvider<UserModel>((ref) {
  return UserRepository.dummy;
});
