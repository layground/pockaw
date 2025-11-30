import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/components/form_fields/custom_confirm_checkbox.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/budget/presentation/components/budget_date_range_picker.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';
import 'package:pockaw/features/budget/presentation/riverpod/date_picker_provider.dart'
    as budget_date_provider; // Alias to avoid conflict
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/user_activity/data/enum/user_activity_action.dart';
import 'package:pockaw/features/user_activity/riverpod/user_activity_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

class BudgetFormScreen extends HookConsumerWidget {
  final int? budgetId; // For editing
  const BudgetFormScreen({super.key, this.budgetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.read(activeWalletProvider);
    final defaultCurrency = wallet.asData?.value?.currencyByIsoCode(ref).symbol;
    final isEditing = budgetId != null;
    final budgetDetails = isEditing
        ? ref.watch(budgetDetailsProvider(budgetId!))
        : null;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final amountController = useTextEditingController();
    final walletController = useTextEditingController();
    final categoryController = useTextEditingController(); // For display text

    final selectedCategory = useState<CategoryModel?>(null);
    final selectedWallet = ref.watch(activeWalletProvider); // For fund source
    final isRoutine = useState(false);

    final activeWalletsAsync = ref.watch(activeWalletProvider);
    final allBudgetsAsync = ref.watch(budgetListProvider);

    useEffect(() {
      walletController.text =
          '${activeWalletsAsync.asData?.value?.currencyByIsoCode(ref).symbol} ${activeWalletsAsync.asData?.value?.balance.toPriceFormat()}';

      if (isEditing && budgetDetails is AsyncData<BudgetModel?>) {
        final budget = budgetDetails.value;
        if (budget != null) {
          amountController.text =
              '$defaultCurrency ${budget.amount.toPriceFormat()}';
          selectedCategory.value = budget.category;
          categoryController.text = budget.category.title; // Simplified display
          isRoutine.value = budget.isRoutine;
        }
      } else if (!isEditing) {
        // Set default wallet if available
        if (activeWalletsAsync is AsyncData<WalletModel?> &&
            activeWalletsAsync.value != null) {}
      }
      return null;
    }, [isEditing, budgetDetails, activeWalletsAsync]);

    final remainingBudgetForEntry = useMemoized<double?>(() {
      final wallet = selectedWallet.asData?.value;
      final budgets = allBudgetsAsync.asData?.value;

      // Don't calculate if essential data is missing
      if (wallet == null || budgets == null) {
        return null;
      }
      // If editing, we also need the original budget details to be loaded
      if (isEditing && budgetDetails?.hasValue != true) {
        return null;
      }

      double totalExistingBudgetsAmount = budgets.fold(
        0.0,
        (sum, budget) => sum + budget.amount,
      );

      if (isEditing) {
        final budget = budgetDetails?.value;
        if (budget != null) {
          // When editing, subtract the original amount of the current budget
          // to correctly calculate the available balance for the new amount.
          totalExistingBudgetsAmount -= budget.amount;
        }
      }

      final availableAmount = wallet.balance - totalExistingBudgetsAmount;
      return availableAmount;
    }, [selectedWallet, allBudgetsAsync, budgetDetails]);

    final amountLabel = remainingBudgetForEntry != null
        ? 'Amount (Available: ${remainingBudgetForEntry.toPriceFormat()})'
        : 'Amount';

    void saveBudget() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (selectedCategory.value == null) {
        Toast.show(
          'Please select a category.',
          type: ToastificationType.warning,
        );
        return;
      }
      if (selectedWallet.value == null) {
        Toast.show(
          'Please select a fund source (wallet).',
          type: ToastificationType.warning,
        );
        return;
      }

      final dateRange = ref.read(budget_date_provider.datePickerProvider);
      if (dateRange.length < 2 ||
          dateRange[0] == null ||
          dateRange[1] == null) {
        Toast.show(
          'Please select a valid date range.',
          type: ToastificationType.warning,
        );
        return;
      }

      // --- Wallet Balance Validation ---
      final newAmount = amountController.text.takeNumericAsDouble();
      final activeWalletBalance = selectedWallet.value!.balance;

      // Get all budgets to calculate the current total
      final allBudgetsAsync = ref.read(budgetListProvider);
      final allBudgets = allBudgetsAsync.asData?.value ?? [];

      double totalExistingBudgetsAmount = allBudgets.fold(
        0.0,
        (sum, budget) => sum + budget.amount,
      );

      // If editing, subtract the original amount of this budget from the total
      if (isEditing &&
          budgetDetails is AsyncData<BudgetModel?> &&
          budgetDetails.value != null) {
        totalExistingBudgetsAmount -= budgetDetails.value!.amount;
      }

      if (totalExistingBudgetsAmount + newAmount > activeWalletBalance) {
        Toast.show(
          'Total budget amount cannot exceed wallet balance.',
          type: ToastificationType.warning,
        );
        return;
      }

      final budgetToSave = BudgetModel(
        id: isEditing ? budgetId : null,
        wallet: selectedWallet.value!,
        category: selectedCategory.value!,
        amount: amountController.text.takeNumericAsDouble(),
        startDate: dateRange[0]!,
        endDate: dateRange[1]!,
        isRoutine: isRoutine.value,
      );

      final budgetDao = ref.read(budgetDaoProvider);
      try {
        if (isEditing) {
          await budgetDao.updateBudget(budgetToSave);
          Toast.show('Budget updated!', type: ToastificationType.success);
        } else {
          await budgetDao.addBudget(budgetToSave);
          Toast.show('Budget created!', type: ToastificationType.success);
        }

        ref
            .read(userActivityServiceProvider)
            .logActivity(
              action: isEditing
                  ? UserActivityAction.budgetUpdated
                  : UserActivityAction.budgetCreated,
              subjectId: budgetToSave.id,
            );

        if (context.mounted) context.pop();
      } catch (e) {
        Log.e('Failed to save budget: $e');
        Toast.show('Failed to save budget: $e', type: ToastificationType.error);
      }
    }

    return CustomScaffold(
      context: context,
      title: isEditing ? 'Edit Budget' : 'Create Budget',
      showBackButton: true,
      showBalance: false,
      actions: [
        if (isEditing)
          CustomIconButton(
            context,
            onPressed: () async {
              // Show confirmation dialog
              context.openBottomSheet(
                child: AlertBottomSheet(
                  title: 'Delete Budget',
                  content: Text(
                    'Are you sure you want to delete this budget?',
                    style: AppTextStyles.body2,
                  ),
                  onConfirm: () async {
                    context.pop(); // close dialog
                    context.pop(); // close form
                    context.pop(); // close detail screen

                    ref.read(budgetDaoProvider).deleteBudget(budgetId!);

                    ref
                        .read(userActivityServiceProvider)
                        .logActivity(
                          action: UserActivityAction.budgetDeleted,
                          subjectId: budgetId,
                        );

                    Toast.show('Budget deleted!');
                  },
                ),
              );
            },
            icon: HugeIcons.strokeRoundedDelete02,
            themeMode: context.themeMode,
          ),
      ],
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isEditing && budgetDetails == null ||
              budgetDetails is AsyncLoading)
            const Center(child: CircularProgressIndicator())
          else if (isEditing && budgetDetails is AsyncError)
            Center(child: Text('Error loading budget: ${budgetDetails?.error}'))
          else
            Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.spacing16,
                  AppSpacing.spacing12,
                  AppSpacing.spacing16,
                  100,
                ),
                child: Column(
                  spacing: AppSpacing.spacing16,
                  children: [
                    CustomSelectField(
                      context: context,
                      controller: walletController,
                      label: activeWalletsAsync.value?.name,
                      prefixIcon: HugeIcons.strokeRoundedWallet01,
                      onTap: () {},
                    ),
                    CustomSelectField(
                      context: context,
                      controller: categoryController,
                      label: 'Category',
                      hint: 'Select Category',
                      isRequired: true,
                      prefixIcon: HugeIcons.strokeRoundedStructure01,
                      onTap: () async {
                        final CategoryModel? result = await context.push(
                          Routes.categoryList,
                        );
                        if (result != null) {
                          selectedCategory.value = result;
                          categoryController.text =
                              result.title; // Or more detailed text
                        }
                      },
                    ),
                    CustomNumericField(
                      controller: amountController,
                      label: amountLabel,
                      hint: '1,000.00',
                      icon: HugeIcons.strokeRoundedCoins01,
                      appendCurrencySymbolToHint: true,
                      isRequired: true,
                    ),
                    const BudgetDateRangePicker(), // Manages its own state via provider
                    CustomConfirmCheckbox(
                      title: 'Mark this budget as routine',
                      subtitle: 'No need to create this budget every time.',
                      checked: isRoutine.value,
                      onChanged: () => isRoutine.value = !isRoutine.value,
                    ),
                  ],
                ),
              ),
            ),
          PrimaryButton(
            label: 'Save Budget',
            onPressed: saveBudget,
          ).floatingBottomContained,
        ],
      ),
    );
  }
}
