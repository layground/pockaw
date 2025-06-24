import 'package:pockaw/features/authentication/data/models/user_model.dart';

class UserRepository {
  static UserModel get dummy =>
      UserModel(id: 1, name: '', email: '', password: '');
}
