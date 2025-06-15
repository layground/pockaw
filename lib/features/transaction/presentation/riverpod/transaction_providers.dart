import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/database/tables/transaction_table.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/category/data/repositories/category_repo.dart';
import 'package:pockaw/features/transaction/data/model/transaction_model.dart';

/// Emits a new list of all Goal rows whenever the table changes
final transactionListProvider =
    StreamProvider.autoDispose<List<TransactionModel>>((ref) {
      final db = ref.watch(databaseProvider);
      final flatCategories = categories.getAllCategories();
      return db.transactionDao.watchAllTransactions().map(
        (event) => event.map((e) {
          final CategoryModel category = flatCategories.firstWhere(
            (element) => element.id == e.categoryId,
            orElse: () => flatCategories.first,
          );
          return e.toModel(category: category);
        }).toList(),
      );
    });

final transactionListProviderReadOnly =
    FutureProvider.autoDispose<List<TransactionModel>>((ref) async {
      final db = ref.watch(databaseProvider);
      final flatCategories = categories.getAllCategories();
      final all = await db.transactionDao.getAllTransactions();
      return all.map((e) {
        final CategoryModel category = flatCategories.firstWhere(
          (element) => element.id == e.categoryId,
          orElse: () => flatCategories.first,
        );
        return e.toModel(category: category);
      }).toList();
    });

final transactionDetailsProvider = StreamProvider.autoDispose
    .family<TransactionModel, int>((ref, id) {
      final db = ref.watch(databaseProvider);
      final flatCategories = categories.getAllCategories();

      return db.transactionDao.watchTransactionByID(id).map((event) {
        final CategoryModel category = flatCategories.firstWhere(
          (element) => element.id == event.categoryId,
          orElse: () => flatCategories.first,
        );
        return event.toModel(category: category);
      });
    });
