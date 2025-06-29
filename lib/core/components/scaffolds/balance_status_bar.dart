part of 'custom_scaffold.dart';

class BalanceStatusBar extends PreferredSize {
  BalanceStatusBar({super.key})
    : super(
        preferredSize: const Size.fromHeight(35),
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.spacing8,
            bottom: AppSpacing.spacing8,
          ),
          child: BalanceStatusBarContent(),
        ),
      );
}
