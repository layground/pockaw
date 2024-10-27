import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:buddyjet/ui/widgets/custom_keyboard/custom_keyboard.dart';
import 'package:buddyjet/utils/extensions/popup_extension.dart';
import 'package:buddyjet/utils/extensions/text_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _amountController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.openCustomKeyboard(_amountController);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    final roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    final customKeyboard = CustomKeyboard(
      controller: _amountController,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Gap(10),
              TextFormField(
                keyboardType: TextInputType.text,
                style: context.textTitleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: roundedBorder,
                  enabledBorder: roundedBorder,
                  focusedBorder: roundedBorder.copyWith(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  hintText: 'Enter expense title...',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  prefixIcon: const Icon(TablerIcons.text_color),
                ),
              ),
              const Gap(20),
              TextFormField(
                readOnly: true,
                keyboardType: TextInputType.text,
                style: context.textTitleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: roundedBorder,
                  enabledBorder: roundedBorder,
                  focusedBorder: roundedBorder.copyWith(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  hintText: 'Select category',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  prefixIcon: const Icon(TablerIcons.category),
                  suffixIcon: const Icon(
                    TablerIcons.chevron_right,
                    size: 18,
                  ),
                ),
              ),
              const Gap(20),
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: TextFormField(
                  readOnly: true,
                  style: context.textTitleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: roundedBorder,
                    enabledBorder: roundedBorder,
                    focusedBorder: roundedBorder.copyWith(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    hintText: 'Transaction date',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    prefixIcon: const Icon(TablerIcons.calendar),
                    suffixIcon: const Icon(
                      TablerIcons.chevron_right,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const Gap(20),
              TextFormField(
                minLines: 1,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: context.textTitleMedium,
                decoration: InputDecoration(
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  hintText: 'Write note ',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                ),
              ),
              const Gap(40),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Transaction Amount',
                    style: context.textLabelSmall,
                  ),
                  Icon(
                    TablerIcons.chevron_down,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              AutoSizeTextFormField(
                autofocus: true,
                controller: _amountController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                style: context.textDisplayMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                readOnly: true,
                onTap: () => context.openCustomKeyboard(_amountController),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '0',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
