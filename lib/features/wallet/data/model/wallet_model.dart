import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart'; // For currency formatting in the extension

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

/// Represents a user's wallet or financial account.
@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    /// The unique identifier for the wallet.
    required int id,

    /// The name of the wallet (e.g., "Primary Checking", "Savings").
    required String name,

    /// The current balance of the wallet.
    required double balance,

    /// The currency code for the wallet's balance (e.g., "USD", "EUR", "NGN").
    required String currency,

    /// Optional: The identifier or name of the icon associated with this wallet.
    String? iconName,

    /// Optional: The color associated with this wallet, stored as a hex string or int.
    String? colorHex, // Or int colorValue
  }) = _WalletModel;

  /// Creates a `WalletModel` instance from a JSON map.
  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}

/// Utility extensions for the [WalletModel].
extension WalletModelUtils on WalletModel {
  /// Formats the balance with the appropriate currency symbol and formatting.
  /// Note: For more robust currency formatting, consider a dedicated currency utility or package.
  String get formattedBalance {
    final format = NumberFormat.currency(
      locale: 'en_US',
      symbol: currency,
    ); // Basic example, locale might need to be dynamic
    return format.format(balance);
  }
}
