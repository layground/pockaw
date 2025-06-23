import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/category/presentation/riverpod/category_actions_provider.dart';

// Category form states
enum CategoryFormStatus { idle, loading, success, error }

class CategoryFormState {
  final CategoryFormStatus status;
  final String? errorMessage;

  const CategoryFormState._(this.status, [this.errorMessage]);

  const CategoryFormState.idle() : this._(CategoryFormStatus.idle);
  const CategoryFormState.loading() : this._(CategoryFormStatus.loading);
  const CategoryFormState.success() : this._(CategoryFormStatus.success);
  const CategoryFormState.error(String msg)
      : this._(CategoryFormStatus.error, msg);
}

class CategoryFormNotifier extends StateNotifier<CategoryFormState> {
  final CategoryActions actions;
  CategoryFormNotifier(this.actions) : super(const CategoryFormState.idle());

  Future<void> submit(CategoriesCompanion entry) async {
    state = const CategoryFormState.loading();
    try {
      final id = await actions.add(entry);
      print(
          '📝 CategoryFormNotifier: Category added with ID: $id'); // Log success
      state = const CategoryFormState.success();
    } catch (e) {
      print('❌ CategoryFormNotifier: Error adding category: $e'); // Log error
      state = CategoryFormState.error(e.toString());
    }
  }
}

final categoryFormStateProvider =
    StateNotifierProvider<CategoryFormNotifier, CategoryFormState>((ref) {
  final actions = ref.watch(categoryActionsProvider);
  return CategoryFormNotifier(actions);
});
