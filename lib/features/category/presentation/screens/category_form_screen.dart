import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/button_state.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_select_field.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';

class CategoryFormScreen extends HookWidget {
  const CategoryFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();

    return CustomScaffold(
      context: context,
      title: 'Add Category',
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
                  CustomTextField(
                    controller: titleController,
                    label: 'Title',
                    hint: 'Lunch with my friends',
                    isRequired: true,
                    prefixIcon: HugeIcons.strokeRoundedTextSmallcaps,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(AppSpacing.spacing16),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        SizedBox(
                          height: double.infinity,
                          child: SecondaryButton(
                            onPressed: () {},
                            icon: HugeIcons.strokeRoundedShoppingBag01,
                          ),
                        ),
                        const Gap(AppSpacing.spacing8),
                        Expanded(
                          child: CustomSelectField(
                            label: 'Category',
                            hint: 'Groceries • Cosmetics',
                            onTap: () {
                              context.push(Routes.categoryListPickingParent);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomTextField(
                    label: 'Description',
                    hint: 'Write simple description...',
                    prefixIcon: HugeIcons.strokeRoundedNote,
                    suffixIcon: HugeIcons.strokeRoundedAlignLeft,
                    minLines: 1,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          PrimaryButton(
            label: 'Save',
            state: ButtonState.active,
            onPressed: () {},
          ).floatingBottom,
        ],
      ),
    );
  }
}
