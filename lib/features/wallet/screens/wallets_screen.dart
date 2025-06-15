import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:pockaw/features/wallet/screens/wallet_form_bottom_sheet.dart';

class WalletsScreen extends ConsumerWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWalletsAsync = ref.watch(allWalletsStreamProvider);

    return CustomScaffold(
      context: context,
      title: 'Manage Wallets',
      showBalance: false,
      actions: [
        CustomIconButton(
          icon: HugeIcons.strokeRoundedAdd01,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              builder: (_) => WalletFormBottomSheet(),
            );
          },
        ),
      ],
      body: allWalletsAsync.when(
        data: (wallets) {
          if (wallets.isEmpty) {
            return const Center(
              child: Text('No wallets found. Add one to get started!'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacing4,
                ),
                child: ListTile(
                  leading: Icon(
                    HugeIcons.strokeRoundedWallet02, // Or use wallet.iconName
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(wallet.name, style: AppTextStyles.body1),
                  subtitle: Text(
                    wallet.formattedBalance,
                    style: AppTextStyles.body3,
                  ),
                  trailing: IconButton(
                    icon: const Icon(HugeIcons.strokeRoundedEdit02, size: 20),
                    onPressed: () {
                      final defaultCurrencies = ref.read(
                        currenciesStaticProvider,
                      );

                      final selectedCurrency = defaultCurrencies.firstWhere(
                        (currency) => currency.isoCode == wallet.currency,
                        orElse: () => defaultCurrencies.first,
                      );

                      ref.read(currencyProvider.notifier).state =
                          selectedCurrency;

                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => WalletFormBottomSheet(wallet: wallet),
                      );
                    },
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.spacing8),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
