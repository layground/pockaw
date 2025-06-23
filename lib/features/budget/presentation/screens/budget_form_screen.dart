import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_confirm_checkbox.dart';
import 'package:pockaw/core/components/form_fields/custom_numeric_field.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/budget/presentation/components/budget_date_range_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/db/database_provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pockaw/core/db/app_database.dart';

class BudgetFormScreen extends StatefulWidget {
  const BudgetFormScreen({super.key});

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _timeline = 'monthly';
  final Map<String, String> _timelineLabels = {
    'daily': 'Daily',
    'weekly': 'Weekly',
    'monthly': 'Monthly',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _selectTimeline() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Daily'),
                onTap: () => Navigator.pop(context, 'daily'),
                selected: _timeline == 'daily',
              ),
              ListTile(
                title: const Text('Weekly'),
                onTap: () => Navigator.pop(context, 'weekly'),
                selected: _timeline == 'weekly',
              ),
              ListTile(
                title: const Text('Monthly'),
                onTap: () => Navigator.pop(context, 'monthly'),
                selected: _timeline == 'monthly',
              ),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != _timeline) {
      setState(() {
        _timeline = selected;
      });
    }
  }

  Future<void> _saveBudget(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final name = _nameController.text.trim();
    final amountText =
        _amountController.text.replaceAll(RegExp(r'[^0-9\.]'), '');
    final amount = double.tryParse(amountText) ?? 0.0;
    print(
        '[BudgetForm] Extracted data: name="$name", amount=$amount, timeline=$_timeline');
    if (name.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name and amount.')),
      );
      return;
    }
    final id = await db.addBudget(BudgetsCompanion(
      name: drift.Value(name),
      amount: drift.Value(amount),
      timeline: drift.Value(_timeline),
    ));
    print('[BudgetForm] Budget added to table with id: $id');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget saved!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomScaffold(
          context: context,
          title: 'Edit Budget',
          showBackButton: true,
          showBalance: false,
          actions: [
            CustomIconButton(
              onPressed: () {},
              iconWidget: Icon(TablerIcons.trash),
              color: AppColors.red,
              borderColor: AppColors.redAlpha10,
              backgroundColor: AppColors.redAlpha10,
            ),
          ],
          body: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.spacing20),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Enter budget name',
                      prefixIcon: TablerIcons.edit,
                      isRequired: true,
                    ),
                    const Gap(AppSpacing.spacing16),
                    CustomNumericField(
                      controller: _amountController,
                      label: 'Amount',
                      hint: '\$ 34',
                      icon: TablerIcons.coin,
                      isRequired: true,
                    ),
                    const Gap(AppSpacing.spacing16),
                    CustomSelectField(
                      label: 'Budget Timeline',
                      hint: _timelineLabels[_timeline]!,
                      isRequired: true,
                      prefixIcon: TablerIcons.calendar,
                      onTap: _selectTimeline,
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                label: 'Save',
                onPressed: () => _saveBudget(context, ref),
              ).floatingBottom
            ],
          ),
        );
      },
    );
  }
}
