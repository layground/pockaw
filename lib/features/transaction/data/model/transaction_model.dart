import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType { income, expense, transfer }

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    int? id,
    required TransactionType transactionType,
    required double amount,
    required DateTime date,
    required String title,
    required CategoryModel category,
    required WalletModel wallet,
    String? notes,
    String? imagePath,
    bool? isRecurring,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionList on List<TransactionModel> {
  double get totalIncome {
    double total = 0;
    for (var transaction in this) {
      if (transaction.transactionType == TransactionType.income) {
        // Assuming a 'type' field
        total += transaction.amount;
      }
    }
    return total;
  }

  double get totalExpenses {
    double total = 0;
    for (var transaction in this) {
      if (transaction.transactionType == TransactionType.expense) {
        // Assuming a 'type' field
        total += transaction.amount;
      }
    }
    return total;
  }

  double get total {
    double total = 0;
    total = totalIncome - totalExpenses;
    return total;
  }
}
