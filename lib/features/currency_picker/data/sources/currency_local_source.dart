import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';

class CurrencyLocalDataSource {
  Future<List<dynamic>> getCurrencies() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/currencies.json',
    );
    final jsonList = jsonDecode(jsonString);
    Log.d(jsonList, label: 'currencies');
    // Log.d('currencies: ${jsonList.runtimeType}');
    return jsonList['currencies'];
  }

  static const Currency dummy = Currency(
    symbol: AppConstants.defaultCurrencySymbol,
    name: 'United States Dollar',
    decimalDigits: 2,
    rounding: 0,
    isoCode: 'USD',
    namePlural: 'US Dollars',
    country: 'United States',
    countryCode: 'US',
  );

  List<String> getAvailableCurrencies() {
    return ['ID', 'SG', 'MY', 'CN', 'JP', 'US', 'GB'];
  }
}
