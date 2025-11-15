import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';
import 'package:pockaw/features/currency_picker/data/repositories/currency_repository.dart';
import 'package:pockaw/features/currency_picker/data/sources/currency_local_source.dart';

/// Replace StateProvider&lt;Currency&gt; with a small Notifier so callers can use
/// explicit mutation methods instead of mutating `.state` directly.
class CurrencyNotifier extends Notifier<Currency> {
  @override
  Currency build() {
    return CurrencyLocalDataSource.dummy;
  }

  void setCurrency(Currency c) => state = c;
}

final currencyProvider = NotifierProvider<CurrencyNotifier, Currency>(
  CurrencyNotifier.new,
);

/// This provider will be filled by currenciesProvider on SplashScreen.
class CurrenciesStaticNotifier extends Notifier<List<Currency>> {
  @override
  List<Currency> build() => <Currency>[];

  void setCurrencies(List<Currency> list) => state = list;

  Currency getCurrencyByISOCode(String? countryCode) => state.firstWhere(
    (currency) => currency.countryCode == countryCode,
    orElse: () => CurrencyLocalDataSource.dummy,
  );

  void clear() => state = [];
}

final currenciesStaticProvider =
    NotifierProvider<CurrenciesStaticNotifier, List<Currency>>(
      CurrenciesStaticNotifier.new,
    );

final currenciesProvider = FutureProvider.autoDispose<List<Currency>>(
  (ref) async {
    final currenciesRepo = CurrencyRepositoryImpl();
    return currenciesRepo.fetchCurrencies();
  },
);
