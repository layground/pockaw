import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/small_button.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class WalletSwitcherDropdown extends ConsumerWidget {
  const WalletSwitcherDropdown({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final wallet = ref.watch(walletProvider);

    return SmallButton(
      prefixIcon: HugeIcons.strokeRoundedWallet01,
      label: wallet.name,
      suffixIcon: HugeIcons.strokeRoundedArrowDown01,
      onTap: () {},
    );
  }
}
