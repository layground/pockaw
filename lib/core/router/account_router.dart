import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/account_picker/presentation/screens/account_picker_screen.dart';
import 'package:pockaw/features/account_form/presentation/screens/account_form_screen.dart';

class AccountRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.accountList,
      builder: (context, state) {
        final String? initialType = state.extra as String?;
        print(
            '📝 AccountRouter: Received initialType for AccountPickerScreen: ${initialType}');
        return AccountPickerScreen(initialType: initialType);
      },
    ),
    GoRoute(
      path: Routes.accountForm,
      builder: (context, state) {
        final String? initialType = state.extra as String?;
        print(
            '📝 AccountRouter: Received initialType for AccountFormScreen: ${initialType}');
        return AccountFormScreen(initialType: initialType);
      },
    ),
  ];
}
