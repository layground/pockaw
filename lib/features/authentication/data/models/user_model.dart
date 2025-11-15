import 'dart:io';

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

  /// has valid profile picture file path
  bool get hasLocalProfilePicture {
    if (profilePicture == null) return false;
    // check if the file exists
    if (profilePicture!.isEmpty) return false;

    if (!File(profilePicture!).existsSync()) return false;

    // check if the image extension is valid, check if the path is ending with extensions
    final validExtensions = ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'];
    // loop through valid extensions to see if any matches
    for (var other in validExtensions) {
      if (profilePicture!.endsWith(other)) return true;
    }

    return false;
  }

  /// Is profile picture a network URL?
  bool get hasNetworkProfilePicture {
    if (profilePicture == null) return false;
    return profilePicture!.startsWith('http://') ||
        profilePicture!.startsWith('https://');
  }

  /// check if has any profile picture
  bool get hasProfilePicture {
    /* Log.d(
      profilePicture,
      label: 'profile picture',
    ); */
    return hasLocalProfilePicture || hasNetworkProfilePicture;
  }
}
