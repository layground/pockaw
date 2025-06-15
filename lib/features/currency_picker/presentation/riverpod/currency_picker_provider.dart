import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';
import 'package:pockaw/features/currency_picker/data/repositories/currency_repository.dart';
import 'package:pockaw/features/currency_picker/data/sources/currency_local_source.dart';

final currencyProvider = StateProvider<Currency>((ref) {
  return CurrencyLocalDataSource.dummy;
});

final currenciesStaticProvider = StateProvider<List<Currency>>((ref) {
  // Initialize with an empty list, which is good practice.
  return <Currency>[];
});

final currenciesProvider = FutureProvider.autoDispose<List<Currency>>((
  ref,
) async {
  final currenciesRepo = CurrencyRepositoryImpl();
  return currenciesRepo.fetchCurrencies();
});
