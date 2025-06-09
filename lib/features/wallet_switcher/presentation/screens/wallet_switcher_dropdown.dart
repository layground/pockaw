import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/small_button.dart';

class WalletSwitcherDropdown extends StatelessWidget {
  const WalletSwitcherDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallButton(
      prefixIcon: HugeIcons.strokeRoundedWallet01,
      label: 'E-Wallet',
      suffixIcon: HugeIcons.strokeRoundedArrowDown01,
      onTap: () {},
    );
  }
}
