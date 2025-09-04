import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/features/currency_picker/data/sources/currency_local_source.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:pockaw/features/wallet/screens/wallet_form_bottom_sheet.dart';

class CreateFirstWalletField extends HookConsumerWidget {
  const CreateFirstWalletField({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(activeWalletProvider).valueOrNull;
    final initialText = wallet != null
        ? '${wallet.currencyByIsoCode(ref).symbol} ${wallet.balance.toPriceFormat()}'
        : 'Setup Wallet'; // Fallback if no active wallet

    final textController = useTextEditingController(text: initialText);

    useEffect(() {
      final newText = wallet != null
          ? '${wallet.currencyByIsoCode(ref).symbol} ${wallet.balance.toPriceFormat()}'
          : 'Setup Wallet';
      if (textController.text != newText) {
        textController.text = newText;
      }
      return null;
    }, [wallet]);

    return CustomTextField(
      context: context,
      controller: textController,
      label: wallet?.name ?? 'Wallet', // Fallback label
      hint: wallet != null ? '' : 'Tap to setup your first wallet',
      prefixIcon: HugeIcons.strokeRoundedWallet01,
      suffixIcon: HugeIcons.strokeRoundedAdd01,
      readOnly: true,
      onTap: () {
        if (wallet == null) {
          context.openBottomSheet(
            child: WalletFormBottomSheet(
              wallet: defaultWallets.first,
              showDeleteButton: false,
            ),
          );
        } else {
          final defaultCurrencies = ref.read(currenciesStaticProvider);

          final selectedCurrency = defaultCurrencies.firstWhere(
            (currency) => currency.isoCode == wallet.currency,
            orElse: () => CurrencyLocalDataSource.dummy,
          );

          ref.read(currencyProvider.notifier).state = selectedCurrency;

          context.openBottomSheet(
            child: WalletFormBottomSheet(
              wallet: wallet,
              showDeleteButton: false,
            ),
          );
        }
      },
    );
  }
}
