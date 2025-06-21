import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_confirm_checkbox.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/double_extension.dart';
import 'package:pockaw/core/extensions/string_extension.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/budget/data/model/budget_model.dart';
import 'package:pockaw/features/budget/presentation/components/budget_date_range_picker.dart';
import 'package:pockaw/features/budget/presentation/riverpod/budget_providers.dart';
import 'package:pockaw/features/budget/presentation/riverpod/date_picker_provider.dart'
    as budget_date_provider; // Alias to avoid conflict
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

class BudgetFormScreen extends HookConsumerWidget {
  final int? budgetId; // For editing
  const BudgetFormScreen({super.key, this.budgetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = budgetId != null;
    final budgetDetails = isEditing
        ? ref.watch(budgetDetailsProvider(budgetId!))
        : null;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final amountController = useTextEditingController();
    final categoryController = useTextEditingController(); // For display text

    final selectedCategory = useState<CategoryModel?>(null);
    final selectedWallet = ref.watch(activeWalletProvider); // For fund source
    final isRoutine = useState(false);

    final activeWalletsAsync = ref.watch(activeWalletProvider);

    useEffect(() {
      if (isEditing && budgetDetails is AsyncData<BudgetModel?>) {
        final budget = budgetDetails.value;
        if (budget != null) {
          amountController.text =
              '${budget.wallet.currency} ${budget.amount.toPriceFormat()}';
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

    void saveBudget() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (selectedCategory.value == null) {
        toastification.show(
          description: const Text('Please select a category.'),
        );
        return;
      }
      if (selectedWallet.value == null) {
        toastification.show(
          description: const Text('Please select a fund source (wallet).'),
        );
        return;
      }

      final dateRange = ref.read(budget_date_provider.datePickerProvider);
      if (dateRange.length < 2 ||
          dateRange[0] == null ||
          dateRange[1] == null) {
        toastification.show(
          description: const Text('Please select a valid date range.'),
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
          toastification.show(description: const Text('Budget updated!'));
        } else {
          await budgetDao.addBudget(budgetToSave);
          toastification.show(description: const Text('Budget created!'));
        }
        if (context.mounted) context.pop();
      } catch (e) {
        Log.e('Failed to save budget: $e');
        toastification.show(
          description: Text('Failed to save budget: $e'),
          type: ToastificationType.error,
        );
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
            onPressed: () async {
              // Show confirmation dialog
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) => AlertBottomSheet(
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
                    toastification.show(
                      description: const Text('Budget deleted!'),
                    );
                  },
                ),
              );
            },
            icon: HugeIcons.strokeRoundedDelete01,
            color: AppColors.red,
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
                  AppSpacing.spacing20,
                  AppSpacing.spacing20,
                  AppSpacing.spacing20,
                  100,
                ),
                child: Column(
                  children: [
                    CustomSelectField(
                      controller: categoryController,
                      label: 'Category',
                      hint: 'Select Category',
                      isRequired: true,
                      prefixIcon: HugeIcons.strokeRoundedPackage,
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
                    const Gap(AppSpacing.spacing16),
                    CustomNumericField(
                      controller: amountController,
                      label: 'Amount',
                      hint: 'e.g. 500',
                      icon: HugeIcons.strokeRoundedCoins01,
                      isRequired: true,
                    ),
                    const Gap(AppSpacing.spacing16),
                    const BudgetDateRangePicker(), // Manages its own state via provider
                    const Gap(AppSpacing.spacing16),
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
          ).floatingBottom,
        ],
      ),
    );
  }
}
