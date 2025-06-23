import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart'
    show ButtonChip;
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/account_picker/presentation/components/account_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/features/account/presentation/riverpod/account_actions_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pockaw/features/account_picker/presentation/riverpod/accounts_list_provider.dart';
import 'package:pockaw/core/db/app_database.dart'; // Import Account model

class AccountPickerScreen extends HookConsumerWidget {
  final String? initialType; // New parameter to receive initial type
  const AccountPickerScreen({
    super.key,
    this.initialType, // Initialize new parameter
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsyncValue = ref.watch(accountsListProvider);
    final String currentType =
        initialType ?? 'expense'; // Use initialType directly

    print(
        '📝 AccountPickerScreen: Displaying accounts for type: ${currentType}'); // Log the type being displayed

    return CustomScaffold(
      context: context,
      title:
          'Pick ${currentType == 'expense' ? 'Expense' : 'Income'} Account', // Dynamic title
      showBalance: false,
      body: Stack(
        children: [
          ListView(
            children: [
              accountsAsyncValue.when(
                data: (accounts) {
                  final filteredAccounts = accounts
                      .where((account) =>
                          (account.type == 'Savings Account' ||
                              account.type == 'Checking Account') &&
                          account.transactionType == currentType)
                      .toList();

                  if (filteredAccounts.isEmpty) {
                    print(
                        '📋 AccountPickerScreen: No accounts found for type ${currentType}');
                    return Center(
                        child: Text(
                            'No ${currentType} accounts yet.')); // Updated empty state message
                  }

                  print(
                      '📋 AccountPickerScreen: Displaying ${filteredAccounts.length} accounts for type ${currentType}');

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing20,
                      vertical: AppSpacing.spacing20,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredAccounts.length,
                    itemBuilder: (context, index) {
                      final account = filteredAccounts[index];
                      return AccountTile(
                        title: account.type, // Show the account type
                        onTap: () {
                          print(
                              '📝 AccountPickerScreen: Selected account: ${account.name}'); // Log selection
                          context.pop(account); // Return the selected account
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Gap(AppSpacing.spacing12),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  print(
                      '❌ AccountPickerScreen: Error loading accounts: $error');
                  return Center(child: Text('Error: $error'));
                },
              ),
            ],
          ),
          PrimaryButton(
            label: 'Add New Account',
            state: ButtonState.outlinedActive,
            onPressed: () {
              context.push(Routes.accountForm,
                  extra: currentType); // Pass currentType to AccountForm
              print(
                  '📝 AccountPickerScreen: Navigating to add new account with type: ${currentType}');
            },
          ).floatingBottom,
        ],
      ),
    );
  }
}
