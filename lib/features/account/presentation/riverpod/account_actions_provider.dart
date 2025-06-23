import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';

class AccountActions {
  final AppDatabase db;

  AccountActions(this.db);

  Future<int> add(AccountsCompanion entry) {
    return db.addAccount(entry);
  }

  Stream<List<Account>> watchAll() {
    return db.watchAllAccounts();
  }

  Future<bool> update(Account account) {
    return db.updateAccount(account);
  }

  Future<int> delete(int id) {
    return db.deleteAccount(id);
  }
}

final accountActionsProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AccountActions(db);
});
