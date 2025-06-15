import 'package:go_router/go_router.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/wallet/screens/wallets_screen.dart';

class WalletRouter {
  static final routes = <GoRoute>[
    GoRoute(
      path: Routes.manageWallets,
      builder: (context, state) {
        return WalletsScreen();
      },
    ),
  ];
}
