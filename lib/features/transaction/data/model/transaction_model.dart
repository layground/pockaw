import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType { income, expense, transfer }

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType transactionType,
    required double amount,
    required DateTime date,
    required String title,
    required String category,
    String? notes,
    String? imagePath,
    bool? isRecurring,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
