import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart' hide Account;
import 'package:pockaw/features/account_form/presentation/riverpod/account_form_state_provider.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart';
import 'package:drift/drift.dart' hide Column;

class AccountFormScreen extends HookConsumerWidget {
  final String? initialType;
  const AccountFormScreen({super.key, this.initialType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final initialBalanceController = useTextEditingController();
    final accountFormState = ref.watch(accountFormStateProvider);
    final accountFormNotifier = ref.read(accountFormStateProvider.notifier);

    final selectedAccountType = useState<String?>(null);
    final selectedTransactionType = useState<String>(
      initialType ?? 'expense',
    );

    print(
      '📝 AccountFormScreen: Initial type received: ${initialType}',
    );
    print(
      '📝 AccountFormScreen: Selected transaction type set to: ${selectedTransactionType.value}',
    );

    final accountTypes = ['Savings Account', 'Checking Account'];

    return CustomScaffold(
      context: context,
      title: 'Add Account',
      showBalance: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing16,
                AppSpacing.spacing20,
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (initialType == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonChip(
                          label: 'Expense',
                          active: selectedTransactionType.value == 'expense',
                          onTap: () {
                            selectedTransactionType.value = 'expense';
                            print(
                              '📝 AccountFormScreen: Switched to Expense type',
                            );
                          },
                        ),
                        ButtonChip(
                          label: 'Income',
                          active: selectedTransactionType.value == 'income',
                          onTap: () {
                            selectedTransactionType.value = 'income';
                            print(
                              '📝 AccountFormScreen: Switched to Income type',
                            );
                          },
                        ),
                      ],
                    ),
                  const Gap(AppSpacing.spacing12),
                  CustomTextField(
                    controller: nameController,
                    label: 'Account Name',
                    hint: 'My Savings',
                    isRequired: true,
                    prefixIcon: TablerIcons.wallet,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomSelectField(
                    label: 'Account Type',
                    hint: selectedAccountType.value ?? 'Select Account Type',
                    isRequired: true,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: accountTypes.length,
                              itemBuilder: (context, index) {
                                final type = accountTypes[index];
                                return ListTile(
                                  title: Text(type),
                                  onTap: () {
                                    selectedAccountType.value = type;
                                    print(
                                        '✔️ AccountFormScreen: Selected account type: $type');
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomTextField(
                    controller: initialBalanceController,
                    label: 'Initial Balance',
                    hint: '0.00',
                    isRequired: true,
                    prefixIcon: TablerIcons.currency_dollar,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          if (accountFormState.status == AccountFormStatus.error)
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SnackBar(
                  content: Text(accountFormState.errorMessage ?? 'Error'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              ),
            ),
          PrimaryButton(
            label: accountFormState.status == AccountFormStatus.loading
                ? 'Saving...'
                : 'Save',
            state: ButtonState.active,
            onPressed: accountFormState.status == AccountFormStatus.loading
                ? null
                : () async {
                    final name = nameController.text.trim();
                    final balance =
                        double.tryParse(initialBalanceController.text.trim()) ??
                            0.0;
                    print(
                      '📝 AccountFormScreen: Submitting account...',
                    );
                    await accountFormNotifier.submit(
                      AccountsCompanion(
                        name: Value(name.isEmpty ? 'Untitled' : name),
                        type: Value(selectedAccountType.value ?? 'Unknown'),
                        initialBalance: Value(balance),
                        transactionType: Value(selectedTransactionType.value),
                      ),
                    );
                    if (ref.read(accountFormStateProvider).status ==
                            AccountFormStatus.success &&
                        context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Account saved!')),
                      );
                      print(
                        '✔️ AccountFormScreen: Account saved successfully!',
                      );
                      context.pop();
                    } else if (ref.read(accountFormStateProvider).status ==
                            AccountFormStatus.error &&
                        context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ref.read(accountFormStateProvider).errorMessage ??
                                'Error',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      print(
                        '❌ AccountFormScreen: Failed to save account!',
                      );
                    }
                  },
          ).floatingBottom,
        ],
      ),
    );
  }
}
