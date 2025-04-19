import 'package:pockaw/features/authentication/domain/models/user_model.dart';

class UserRepository {
  static UserModel get dummy => UserModel(id: 1, name: '', email: '');
}
