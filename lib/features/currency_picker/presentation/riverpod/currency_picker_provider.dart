import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';
import 'package:pockaw/features/currency_picker/data/sources/currency_local_source.dart';

final currencyProvider = StateProvider<Currency>((ref) {
  return CurrencyLocalDataSource.dummy;
});
