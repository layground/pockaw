import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';
import 'package:intl/intl.dart';

/// Extension on Transaction to provide UI-specific properties based on type.
extension TransactionUIExtensions on TransactionModel {
  IconData get iconData {
    switch (transactionType) {
      case TransactionType.income:
        return HugeIcons.strokeRoundedArrowDown02;
      case TransactionType.expense:
        return HugeIcons.strokeRoundedArrowUp02;
      case TransactionType.transfer:
        return HugeIcons.strokeRoundedRepeat;
    }
  }

  Color get iconColor {
    switch (transactionType) {
      case TransactionType.income:
        return AppColors.green200;
      case TransactionType.expense:
        return AppColors.red;
      case TransactionType.transfer:
        return AppColors.tertiary;
    }
  }

  Color get backgroundColor {
    switch (transactionType) {
      case TransactionType.income:
        return AppColors.greenAlpha10;
      case TransactionType.expense:
        return AppColors.red50;
      case TransactionType.transfer:
        return AppColors.tertiaryAlpha10;
    }
  }

  Color get borderColor {
    switch (transactionType) {
      case TransactionType.income:
        return AppColors.greenAlpha10;
      case TransactionType.expense:
        return AppColors.redAlpha10;
      case TransactionType.transfer:
        return AppColors.tertiaryAlpha10;
    }
  }

  Color get amountColor {
    switch (transactionType) {
      case TransactionType.income:
        return AppColors.green200;
      case TransactionType.expense:
        return AppColors.red700;
      case TransactionType.transfer:
        return AppColors.neutral700; // Or another appropriate color
    }
  }

  String get amountPrefix {
    switch (transactionType) {
      case TransactionType.income:
        return '+';
      case TransactionType.expense:
        return '-';
      case TransactionType.transfer:
        return ''; // Transfers might not need a prefix
    }
  }

  /// Returns the transaction amount formatted as a string with currency symbol/prefix.
  /// Example: "+1,500.00" or "-45.50"
  String get formattedAmount {
    final NumberFormat currencyFormatter = NumberFormat("#,##0.00", "en_US");
    return '$amountPrefix${currencyFormatter.format(amount)}';
  }

  String get formattedDate {
    return DateFormat('dd MMMM').format(date);
  }
}
