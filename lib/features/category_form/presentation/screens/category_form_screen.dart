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
import 'package:pockaw/core/db/app_database.dart' hide Category;
import 'package:pockaw/features/category_form/presentation/riverpod/category_form_state_provider.dart';
import 'package:pockaw/core/components/buttons/button_chip.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as epf;

class CategoryFormScreen extends HookConsumerWidget {
  final String? initialType; // New parameter to receive initial type
  const CategoryFormScreen({super.key, this.initialType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final categoryFormState = ref.watch(categoryFormStateProvider);
    final categoryFormNotifier = ref.read(categoryFormStateProvider.notifier);

    final selectedIcon = useState<String>('❓'); // Initial placeholder emoji
    final selectedType = useState<String>(
      initialType ?? 'expense',
    ); // Use initialType or default

    print(
      '📝 CategoryFormScreen: Initial type received: ${initialType}',
    ); // Log initial type
    print(
      '📝 CategoryFormScreen: Selected type set to: ${selectedType.value}',
    ); // Log selected type

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
                  if (initialType ==
                      null) // Only show type selection if initialType is not provided
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonChip(
                          label: 'Expense',
                          active: selectedType.value == 'expense',
                          onTap: () {
                            selectedType.value = 'expense';
                            print(
                              '📝 CategoryFormScreen: Switched to Expense type',
                            ); // Log type switch
                          },
                        ),
                        ButtonChip(
                          label: 'Income',
                          active: selectedType.value == 'income',
                          onTap: () {
                            selectedType.value = 'income';
                            print(
                              '📝 CategoryFormScreen: Switched to Income type',
                            ); // Log type switch
                          },
                        ),
                      ],
                    ),
                  const Gap(AppSpacing.spacing12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: titleController,
                          label: 'Title',
                          hint: 'Lunch with my friends',
                          isRequired: true,
                          prefixIcon: TablerIcons.letter_case,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      const Gap(AppSpacing.spacing8),
                      CustomIconButton(
                        onPressed: () {
                          print(
                              '📝 CategoryFormScreen: Icon selection button pressed'); // Log button press
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 250, // Adjust height as needed
                                child: epf.EmojiPicker(
                                  onEmojiSelected: (category, emoji) {
                                    selectedIcon.value = emoji.emoji;
                                    print(
                                        '✔️ CategoryFormScreen: Selected emoji: ${emoji.emoji}'); // Log selected emoji
                                    Navigator.pop(context);
                                  },
                                  config: const epf.Config(
                                    emojiViewConfig: epf.EmojiViewConfig(
                                      columns: 7,
                                      emojiSizeMax: 32,
                                      verticalSpacing: 0,
                                      horizontalSpacing: 0,
                                      gridPadding: EdgeInsets.zero,
                                      backgroundColor: Color(0xFFF2F2F2),
                                    ),
                                    categoryViewConfig: epf.CategoryViewConfig(
                                      initCategory: epf.Category.RECENT,
                                      indicatorColor: Colors.blue,
                                      iconColor: Colors.grey,
                                      iconColorSelected: Colors.blue,
                                      backspaceColor: Colors.blue,
                                    ),
                                    skinToneConfig: epf.SkinToneConfig(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        iconWidget: Text(
                          selectedIcon.value,
                          style: TextStyle(
                              fontSize: _getIconSize(
                                  IconSize.medium)), // Display emoji
                        ),
                        iconSize: IconSize.medium,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.spacing16),
                  CustomTextField(
                    controller: descriptionController,
                    label: 'Description',
                    hint: 'Write simple description...',
                    prefixIcon: TablerIcons.note,
                    suffixIcon: TablerIcons.align_left,
                    minLines: 1,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          if (categoryFormState.status == CategoryFormStatus.error)
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SnackBar(
                  content: Text(categoryFormState.errorMessage ?? 'Error'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              ),
            ),
          PrimaryButton(
            label: categoryFormState.status == CategoryFormStatus.loading
                ? 'Saving...'
                : 'Save',
            state: ButtonState.active,
            onPressed: categoryFormState.status == CategoryFormStatus.loading
                ? null
                : () async {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();
                    print(
                      '📝 CategoryFormScreen: Submitting category...',
                    ); // Log submission attempt
                    await categoryFormNotifier.submit(
                      CategoriesCompanion(
                        title: Value(title.isEmpty ? 'Untitled' : title),
                        type: Value(selectedType.value),
                        icon: Value(selectedIcon.value),
                        description:
                            Value(description.isEmpty ? null : description),
                        // parentId: Value(null), // TODO: Implement parent category selection
                      ),
                    );
                    if (ref.read(categoryFormStateProvider).status ==
                            CategoryFormStatus.success &&
                        context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Category saved!')),
                      );
                      print(
                        '✔️ CategoryFormScreen: Category saved successfully!',
                      ); // Log success
                      context.pop();
                    } else if (ref.read(categoryFormStateProvider).status ==
                            CategoryFormStatus.error &&
                        context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ref.read(categoryFormStateProvider).errorMessage ??
                                'Error',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      print(
                        '❌ CategoryFormScreen: Failed to save category!',
                      ); // Log failure
                    }
                  },
          ).floatingBottom,
        ],
      ),
    );
  }

  // Helper function to get icon size (copied from CustomIconButton to avoid dependency)
  static double _getIconSize(IconSize size) => switch (size) {
        IconSize.large => 26,
        IconSize.medium => 22,
        IconSize.small => 18,
        IconSize.tiny => 14,
      };
}
