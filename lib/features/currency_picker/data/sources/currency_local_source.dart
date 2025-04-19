import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';

class CurrencyLocalDataSource {
  Future<List<dynamic>> getCurrencies() async {
    Log.d('fetching...');
    final jsonString =
        await rootBundle.loadString('assets/data/currencies.json');
    final jsonList = jsonDecode(jsonString);
    Log.d('currencies: $jsonList');
    Log.d('currencies: ${jsonList.runtimeType}');
    return jsonList['currencies'];
  }

  static const Currency dummy = Currency(
    symbol: '',
    name: '',
    decimalDigits: 0,
    rounding: 0,
    isoCode: '',
    namePlural: '',
    country: '',
    countryCode: '',
  );

  List<String> getAvailableCurrencies() {
    return [
      'ID',
      'SG',
      'MY',
      'CN',
      'JP',
      'US',
      'GB',
    ];
  }
}
