import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/transaction/presentation/screens/transaction_form.dart';
import 'package:pockaw/features/transaction/presentation/screens/transaction_test_screen.dart';
import 'package:pockaw/core/db/app_database.dart' as db;

class TransactionRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.transactionForm,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        return TransactionForm(
          initialTitle: extras?['title'],
          initialAmount: extras?['amount'],
          initialDate: extras?['date'],
          initialDescription: extras?['description'],
          initialCategoryTitle: extras?['initialCategoryTitle'] as String?,
          initialAccount: extras?['initialAccount'] as String?,
        );
      },
    ),
    GoRoute(
      path: Routes.transactionTest,
      builder: (context, state) => const TransactionTestScreen(),
    ),
  ];
}
