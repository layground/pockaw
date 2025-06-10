import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/transaction/presentation/screens/transaction_form.dart';

class TransactionRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.transactionForm,
      builder: (context, state) => TransactionForm(transactionID: ''),
    ),
    GoRoute(
      path: '/transaction/:id', // Matches the path used in push
      builder: (context, state) {
        final String transactionId =
            '${state.pathParameters['id']}'; // Access the ID
        // Pass the ID to your TransactionForm or a wrapper widget
        return TransactionForm(transactionID: transactionId);
      },
    ),
  ];
}
