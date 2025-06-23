import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/main/presentation/riverpod/main_page_view_riverpod.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_service_provider.dart';
import 'package:pockaw/core/services/gemini_api_service.dart';
import 'package:pockaw/features/category_picker/presentation/riverpod/categories_list_provider.dart';
import 'package:pockaw/features/account_picker/presentation/riverpod/accounts_list_provider.dart';
import 'package:pockaw/core/db/app_database.dart' as db;

class CustomBottomAppBar extends ConsumerWidget {
  final PageController pageController;
  const CustomBottomAppBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spacing12,
        horizontal: AppSpacing.spacing16,
      ),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            radius: 25,
            icon: TablerIcons.home,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(0),
            onTap: () {
              pageController.jumpToPage(0);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: TablerIcons.receipt,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(1),
            onTap: () {
              pageController.jumpToPage(1);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: TablerIcons.plus,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.light,
            onTap: () {
              context.openBottomSheet(const AddTransactionPopup());
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: TablerIcons.target_arrow,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(2),
            onTap: () {
              pageController.jumpToPage(2);
            },
          ),
          CircleIconButton(
            radius: 25,
            icon: TablerIcons.database_dollar,
            backgroundColor: Colors.transparent,
            foregroundColor:
                ref.read(pageControllerProvider.notifier).getIconColor(3),
            onTap: () {
              pageController.jumpToPage(3);
            },
          ),
        ],
      ),
    );
  }
}

class AddTransactionPopup extends ConsumerWidget {
  const AddTransactionPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final geminiApiService = GeminiApiService();
    final categoriesAsync = ref.watch(categoriesListProvider);
    final accountsAsync = ref.watch(accountsListProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(TablerIcons.scan),
          title: const Text('Scan Transaction'),
          onTap: () async {
            print('DEBUG: Starting Scan Transaction flow');

            if (categoriesAsync.isLoading || accountsAsync.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Please wait, categories and accounts are loading...')),
              );
              return;
            }
            if (categoriesAsync.hasError || accountsAsync.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Error loading data: ${categoriesAsync.error ?? accountsAsync.error}')),
              );
              return;
            }

            List<String> categoryNames =
                categoriesAsync.value?.map((e) => e.title).toList() ?? [];
            List<String> accountNames =
                accountsAsync.value?.map((e) => e.name).toList() ?? [];

            print('DEBUG: Available Categories for Prompt: $categoryNames');
            print('DEBUG: Available Accounts for Prompt: $accountNames');

            try {
              final image = await imageService.takePhoto();
              print('DEBUG: Image capture result: ' +
                  (image != null ? image.path : 'null'));

              if (image != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
                print('DEBUG: Calling Gemini API...');

                final details =
                    await geminiApiService.extractTransactionDetails(image,
                        availableCategories: categoryNames,
                        availableAccounts: accountNames);
                print('DEBUG: Gemini API call completed');
                Navigator.of(context).pop(); // Remove loading dialog

                if (details != null) {
                  print('Gemini Extracted Details:');
                  print(details);

                  final extras = <String, dynamic>{};
                  String? extractedTitle;
                  String? extractedDescription;
                  db.Category? matchedCategory;
                  String? matchedAccount;
                  DateTime? parsedDate;

                  // --- Title Logic ---
                  if (details['merchant'] != null) {
                    extractedTitle = details['merchant'];
                  } else if (details['category'] != null) {
                    extractedTitle = details['category'];
                  } else if (details['description'] != null) {
                    extractedTitle = details['description'];
                  } else if (details['items'] is List &&
                      details['items'].isNotEmpty &&
                      details['items'][0]['item'] != null) {
                    extractedTitle = details['items'][0]['item'];
                  }

                  // --- Description Logic ---
                  if (details['description'] != null &&
                      extractedTitle != details['description']) {
                    extractedDescription = details['description'];
                  } else if (details['items'] is List &&
                      details['items'].isNotEmpty &&
                      details['items'][0]['item'] != null &&
                      extractedTitle != details['items'][0]['item']) {
                    extractedDescription = details['items'][0]['item'];
                  }

                  // --- Category Matching ---
                  if (details['category'] != null && categoriesAsync.hasValue) {
                    final categoryTitle = details['category'].toString();
                    print(
                        'DEBUG: Gemini extracted category name: $categoryTitle');
                    try {
                      matchedCategory = categoriesAsync.value!.firstWhere(
                        (cat) =>
                            cat.title.toLowerCase() ==
                            categoryTitle.toLowerCase(),
                      );
                      print(
                          'DEBUG: Matched category: ${matchedCategory?.title}');
                    } catch (e) {
                      print(
                          'DEBUG: Category not found: $categoryTitle (Error: $e)');
                    }
                  } else if (!categoriesAsync.hasValue) {
                    print(
                        'DEBUG: Categories data not available yet for matching.');
                  } else {
                    print(
                        'DEBUG: details[\'category\'] is null. No category to match.');
                  }

                  // --- Account Matching ---
                  if (details['account'] != null && accountsAsync.hasValue) {
                    final accountName = details['account'].toString();
                    print('DEBUG: Gemini extracted account name: $accountName');
                    try {
                      matchedAccount = accountsAsync.value!
                          .firstWhere(
                            (acc) =>
                                acc.name.toLowerCase() ==
                                accountName.toLowerCase(),
                          )
                          .name;
                      print('DEBUG: Matched account: $matchedAccount');
                    } catch (e) {
                      print(
                          'DEBUG: Account not found: $accountName (Error: $e)');
                    }
                  } else if (!accountsAsync.hasValue) {
                    print(
                        'DEBUG: Accounts data not available yet for matching.');
                  } else {
                    print(
                        'DEBUG: details[\'account\'] is null. No account to match.');
                  }

                  // --- Date Parsing ---
                  if (details['date'] != null) {
                    try {
                      parsedDate = DateTime.parse(details['date'].toString());
                      print('DEBUG: Parsed date: $parsedDate');
                    } catch (e) {
                      print(
                          'DEBUG: Failed to parse date: ${details['date']} (Error: $e)');
                    }
                  } else {
                    print(
                        'DEBUG: details[\'date\'] is null. Defaulting to current date.');
                  }

                  // --- Amount Logic ---
                  double? extractedAmount;
                  print(
                      'DEBUG: Runtime type of details[\'amount\']: ${details['amount']?.runtimeType}');
                  if (details['amount'] != null) {
                    extractedAmount =
                        double.tryParse(details['amount'].toString());
                  } else if (details['total'] != null) {
                    extractedAmount =
                        double.tryParse(details['total'].toString());
                  } else if (details['items'] is List &&
                      details['items'].isNotEmpty &&
                      details['items'][0]['price'] != null) {
                    extractedAmount = double.tryParse(
                        details['items'][0]['price'].toString());
                  }
                  print('DEBUG: Calculated extractedAmount: $extractedAmount');

                  // --- Populate Extras Map ---
                  if (extractedTitle != null) extras['title'] = extractedTitle;
                  if (extractedAmount != null)
                    extras['amount'] = extractedAmount;
                  extras['date'] =
                      parsedDate ?? DateTime.now(); // Always set a date
                  if (extractedDescription != null)
                    extras['description'] = extractedDescription;
                  if (matchedCategory != null)
                    extras['initialCategoryTitle'] = matchedCategory.title;
                  if (matchedAccount != null) {
                    extras['initialAccount'] = matchedAccount;
                  }

                  print('DEBUG: Navigating to TransactionForm with extras:');
                  print(extras);
                  Navigator.of(context).pop(); // Now close the modal
                  context.push(Routes.transactionForm, extra: extras);
                } else {
                  print('DEBUG: No details extracted from Gemini.');
                  Navigator.of(context).pop(); // Now close the modal
                  context.push(Routes.transactionForm);
                }
              } else {
                print('DEBUG: No image captured.');
                Navigator.of(context).pop(); // Now close the modal
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No image captured.')),
                );
              }
            } catch (e, st) {
              print('DEBUG: Exception in Scan Transaction flow: $e');
              print(st);
              if (context.mounted) {
                // Ensure context is still valid before using
                Navigator.of(context)
                    .pop(); // Remove loading dialog if still present
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Camera or Gemini error: $e')),
                );
              }
            }
          },
        ),
        ListTile(
          leading: const Icon(TablerIcons.edit),
          title: const Text('Manual Entry'),
          onTap: () {
            Navigator.of(context).pop();
            context.push(Routes.transactionForm);
          },
        ),
      ],
    );
  }
}
