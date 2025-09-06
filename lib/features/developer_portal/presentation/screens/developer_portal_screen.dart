import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';

class DeveloperPortalScreen extends HookConsumerWidget {
  const DeveloperPortalScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    return CustomScaffold(
      context: context,
      title: 'Developer Portal',
      body: isLoading.value
          ? const Center(child: LoadingIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.spacing20),
              child: Column(
                spacing: AppSpacing.spacing16,
                children: [
                  Text(
                    'Warning! Make sure you are know what you are doing. Use with caution.',
                    style: AppTextStyles.body2.copyWith(color: Colors.orange),
                  ),
                  MenuTileButton(
                    label: 'Reset Categories',
                    icon: HugeIcons.strokeRoundedStructure01,
                    onTap: () async {
                      context.openBottomSheet(
                        isScrollControlled: false,
                        child: AlertBottomSheet(
                          title: 'Reset Categories',
                          content: Text(
                            'Are you sure you want to reset the categories?',
                            style: AppTextStyles.body2,
                          ),
                          onConfirm: () async {
                            isLoading.value = true;
                            context.pop();
                            final db = ref.read(databaseProvider);
                            await db.resetCategories();
                            isLoading.value = false;
                          },
                        ),
                      );
                    },
                  ),
                  MenuTileButton(
                    label: 'Reset Wallets',
                    icon: HugeIcons.strokeRoundedWallet02,
                    onTap: () async {
                      context.openBottomSheet(
                        isScrollControlled: false,
                        child: AlertBottomSheet(
                          title: 'Reset Wallets',
                          content: Text(
                            'Are you sure you want to reset the wallets?',
                            style: AppTextStyles.body2,
                          ),
                          onConfirm: () async {
                            isLoading.value = true;
                            context.pop();
                            final db = ref.read(databaseProvider);
                            await db.resetWallets();
                            isLoading.value = false;
                          },
                        ),
                      );
                    },
                  ),
                  MenuTileButton(
                    label: 'Reset Database',
                    icon: HugeIcons.strokeRoundedDeletePutBack,
                    onTap: () {
                      context.openBottomSheet(
                        isScrollControlled: false,
                        child: AlertBottomSheet(
                          title: 'Reset Database',
                          content: Text(
                            'Are you sure you want to reset the database?',
                            style: AppTextStyles.body2,
                          ),
                          onConfirm: () async {
                            isLoading.value = true;
                            context.pop();
                            final db = ref.read(databaseProvider);
                            await db.clearAllDataAndReset();
                            await db.populateData();
                            isLoading.value = false;
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
