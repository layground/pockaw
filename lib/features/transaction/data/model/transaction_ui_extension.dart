import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';

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

  Color backgroundColor(BuildContext context, ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      return AppColors.neutralAlpha25;
    }

    return AppColors.neutral50;
  }

  Color foregroundColor(BuildContext context, ThemeMode themeMode) {
    switch (transactionType) {
      case TransactionType.income:
        return context.incomeForeground;
      case TransactionType.expense:
        return context.expenseForeground;
      case TransactionType.transfer:
        return AppColors.tertiaryAlpha10;
    }
  }

  Color iconBackgroundColor(BuildContext context, ThemeMode themeMode) {
    switch (transactionType) {
      case TransactionType.income:
        return context.incomeBackground;
      case TransactionType.expense:
        return context.expenseBackground;
      case TransactionType.transfer:
        return AppColors.tertiaryAlpha10;
    }
  }

  Color borderColor(bool isDarkMode) {
    if (isDarkMode) {
      return AppColors.neutralAlpha25;
    }

    return AppColors.neutralAlpha10;
  }

  Color iconBorderColor(bool isDarkMode) {
    switch (transactionType) {
      case TransactionType.income:
        return isDarkMode ? AppColors.greenAlpha20 : AppColors.greenAlpha10;
      case TransactionType.expense:
        return isDarkMode ? AppColors.redAlpha25 : AppColors.redAlpha10;
      case TransactionType.transfer:
        return isDarkMode
            ? AppColors.tertiaryAlpha25
            : AppColors.tertiaryAlpha10;
    }
  }

  Color borderColorLighter(bool isDarkMode) {
    switch (transactionType) {
      case TransactionType.income:
        return isDarkMode ? AppColors.greenAlpha30 : AppColors.greenAlpha30;
      case TransactionType.expense:
        return isDarkMode ? AppColors.redAlpha25 : AppColors.redAlpha10;
      case TransactionType.transfer:
        return isDarkMode
            ? AppColors.tertiaryAlpha25
            : AppColors.tertiaryAlpha25;
    }
  }

  Color get amountColor {
    switch (transactionType) {
      case TransactionType.income:
        return AppColors.green200;
      case TransactionType.expense:
        return AppColors.red700;
      case TransactionType.transfer:
        return AppColors.tertiary600; // Or another appropriate color
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
    return '$amountPrefix${amount.toPriceFormat()}';
  }

  String get formattedDate {
    return date.toRelativeDayFormatted();
  }
}
