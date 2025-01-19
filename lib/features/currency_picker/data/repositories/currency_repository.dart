import 'package:pockaw/features/currency_picker/data/models/currency.dart';
import 'package:pockaw/features/currency_picker/data/sources/currency_local_source.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> fetchCurrencies();
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  @override
  Future<List<Currency>> fetchCurrencies() async {
    final localDataSource = CurrencyLocalDataSource();
    final currencies = await localDataSource.getCurrencies();
    return currencies
        .map((jsonObject) => Currency.fromJson(jsonObject))
        .toList();
  }
}
