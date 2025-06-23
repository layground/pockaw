import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:pockaw/features/transaction/presentation/riverpod/transaction_actions_provider.dart';

// Transaction form states
enum TransactionFormStatus { idle, loading, success, error }

class TransactionFormState {
  final TransactionFormStatus status;
  final String? errorMessage;
  final DateTime selectedDate;
  final String? imagePath;
  final bool isEditing;
  final int? transactionId;

  const TransactionFormState._(
    this.status,
    this.errorMessage,
    this.selectedDate,
    this.imagePath,
    this.isEditing,
    this.transactionId,
  );

  factory TransactionFormState.idle({
    DateTime? selectedDate,
    String? imagePath,
    bool isEditing = false,
    int? transactionId,
  }) {
    return TransactionFormState._(
      TransactionFormStatus.idle,
      null,
      selectedDate ?? DateTime.now(),
      imagePath,
      isEditing,
      transactionId,
    );
  }

  TransactionFormState loading() {
    return TransactionFormState._(
      TransactionFormStatus.loading,
      null,
      selectedDate,
      imagePath,
      isEditing,
      transactionId,
    );
  }

  TransactionFormState success() {
    return TransactionFormState._(
      TransactionFormStatus.success,
      null,
      selectedDate,
      imagePath,
      isEditing,
      transactionId,
    );
  }

  TransactionFormState error(String msg) {
    return TransactionFormState._(
      TransactionFormStatus.error,
      msg,
      selectedDate,
      imagePath,
      isEditing,
      transactionId,
    );
  }

  TransactionFormState copyWith({
    TransactionFormStatus? status,
    String? errorMessage,
    DateTime? selectedDate,
    String? imagePath,
    bool? isEditing,
    int? transactionId,
  }) {
    return TransactionFormState._(
      status ?? this.status,
      errorMessage ?? this.errorMessage,
      selectedDate ?? this.selectedDate,
      imagePath ?? this.imagePath,
      isEditing ?? this.isEditing,
      transactionId ?? this.transactionId,
    );
  }
}

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  final TransactionActions actions;
  TransactionFormNotifier(this.actions) : super(TransactionFormState.idle());

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setImagePath(String? path) {
    state = state.copyWith(imagePath: path);
  }

  void setEditing(bool editing, {int? transactionId}) {
    state = state.copyWith(isEditing: editing, transactionId: transactionId);
  }

  void setError(String message) {
    state = state.error(message);
  }

  Future<void> addTransaction(TransactionsCompanion entry) async {
    state = state.loading();
    try {
      await actions.add(entry);
      state = state.success();
    } catch (e) {
      state = state.error(e.toString());
    }
  }

  Future<void> updateTransaction(int id, TransactionsCompanion entry) async {
    state = state.loading();
    try {
      final transactionToUpdate = Transaction(
        id: id,
        title: entry.title.value,
        amount: entry.amount.value,
        description: entry.description.value,
        date: entry.date.value,
        categoryId: entry.categoryId.value,
        transactionType: entry.transactionType.value,
        accountId: entry.accountId.value,
        imagePath: entry.imagePath.value,
      );
      await actions.update(transactionToUpdate);
      state = state.success();
    } catch (e) {
      state = state.error(e.toString());
    }
  }
}

final transactionFormStateProvider =
    StateNotifierProvider<TransactionFormNotifier, TransactionFormState>((ref) {
  final actions = ref.watch(transactionActionsProvider);
  return TransactionFormNotifier(actions);
});
