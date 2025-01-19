import 'dart:convert';

import 'package:flutter/services.dart';

class CurrencyLocalDataSource {
  Future<List<dynamic>> getCurrencies() async {
    print('fetching...');
    final jsonString =
        await rootBundle.loadString('assets/data/currencies.json');
    final jsonList = jsonDecode(jsonString);
    print('currencies: ${jsonList}');
    print('currencies: ${jsonList.runtimeType}');
    return jsonList['currencies'];
  }

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
