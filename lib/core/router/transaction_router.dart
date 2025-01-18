import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/transaction/presentation/screens/transaction_form.dart';

class TransactionRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.transactionForm,
      builder: (context, state) => TransactionForm(),
    ),
  ];
}
