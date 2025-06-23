import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/account/presentation/riverpod/account_actions_provider.dart';

// Account form states
enum AccountFormStatus { idle, loading, success, error }

class AccountFormState {
  final AccountFormStatus status;
  final String? errorMessage;

  const AccountFormState._(this.status, [this.errorMessage]);

  const AccountFormState.idle() : this._(AccountFormStatus.idle);
  const AccountFormState.loading() : this._(AccountFormStatus.loading);
  const AccountFormState.success() : this._(AccountFormStatus.success);
  const AccountFormState.error(String msg)
      : this._(AccountFormStatus.error, msg);
}

class AccountFormNotifier extends StateNotifier<AccountFormState> {
  final AccountActions actions;
  AccountFormNotifier(this.actions) : super(const AccountFormState.idle());

  Future<void> submit(AccountsCompanion entry) async {
    state = const AccountFormState.loading();
    try {
      final id = await actions.add(entry);
      print(
          '📝 AccountFormNotifier: Account added with ID: $id'); // Log success
      state = const AccountFormState.success();
    } catch (e) {
      print('❌ AccountFormNotifier: Error adding account: $e'); // Log error
      state = AccountFormState.error(e.toString());
    }
  }
}

final accountFormStateProvider =
    StateNotifierProvider<AccountFormNotifier, AccountFormState>((ref) {
  final actions = ref.watch(accountActionsProvider);
  return AccountFormNotifier(actions);
});
