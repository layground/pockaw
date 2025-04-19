import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';
import 'package:pockaw/features/currency_picker/data/sources/currency_local_source.dart'
    show CurrencyLocalDataSource;

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required int id,
    required String name,
    required String email,
    String? profilePicture, // Optional profile picture URL
    @Default(CurrencyLocalDataSource.dummy) Currency currency,
    @Default("IDR") String defaultCurrency, // Default to Indonesian Rupiah
    @Default(false) bool isPremium, // Indicates if user has premium access
    DateTime? createdAt, // Optional account creation date
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
