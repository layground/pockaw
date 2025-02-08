import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pockaw/core/components/buttons/small_button.dart';

class WalletSwitcherDropdown extends StatelessWidget {
  const WalletSwitcherDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallButton(
      prefixIcon: TablerIcons.wallet,
      label: 'E-Wallet',
      suffixIcon: TablerIcons.chevron_down,
      onTap: () {},
    );
  }
}
