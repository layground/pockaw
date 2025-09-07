import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    int? id,
    required String name,
    required String email,
    @Default('') String password,
    String? profilePicture, // Optional profile picture URL
    @Default(false) bool isPremium, // Indicates if user has premium access
    DateTime? createdAt, // Optional account creation date
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelExtensions on UserModel {
  String get username => name.replaceAll(' ', '').toLowerCase();
}
