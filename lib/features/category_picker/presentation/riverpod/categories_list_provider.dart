import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_actions_provider.dart';

final categoriesListProvider =
    StreamProvider.autoDispose<List<Category>>((ref) {
  final categoryActions = ref.watch(categoryActionsProvider);
  return categoryActions.watchAll();
});
