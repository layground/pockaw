part of 'custom_scaffold.dart';

class BalanceStatusBar extends PreferredSize {
  BalanceStatusBar({super.key})
    : super(
        preferredSize: const Size.fromHeight(35),
        child: BalanceStatusBarContent(),
      );
}
