import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/small_button.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:pockaw/features/wallet_switcher/presentation/components/wallet_selector_bottom_sheet.dart';

class WalletSwitcherDropdown extends ConsumerWidget {
  const WalletSwitcherDropdown({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final activeWalletAsync = ref.watch(activeWalletProvider);

    return activeWalletAsync.when(
      data: (wallet) {
        return SmallButton(
          prefixIcon: HugeIcons.strokeRoundedWallet01,
          label: wallet?.name ?? 'No Wallet', // Handle null case
          suffixIcon: HugeIcons.strokeRoundedArrowDown01,
          onTap: () {
            context.openBottomSheet(
              child: const WalletSelectorBottomSheet(),
            );
          },
        );
      },
      loading: () => const SmallButton(
        label: 'Loading...',
        prefixIcon: HugeIcons.strokeRoundedWallet01,
      ),
      error: (err, stack) => SmallButton(
        label: 'Error',
        prefixIcon: HugeIcons.strokeRoundedWallet01,
        onTap: () {},
      ),
    );
  }
}
