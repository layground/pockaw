import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/account/presentation/riverpod/account_actions_provider.dart';

final accountsListProvider = StreamProvider.autoDispose<List<Account>>((ref) {
  final accountActions = ref.watch(accountActionsProvider);
  return accountActions.watchAll();
});
