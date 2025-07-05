import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/database_provider.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/keyboard_service/virtual_keyboard_service.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';
import 'package:toastification/toastification.dart';

final accountDeletionLoadingProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

class AccountDeletionScreen extends HookConsumerWidget {
  const AccountDeletionScreen({super.key});

  Future<void> _showConfirmationSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    KeyboardService.closeKeyboard();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => AlertBottomSheet(
        context: context,
        title: 'Confirm Account Deletion',
        confirmText: 'Delete',
        content: Text(
          'This action is irreversible. All your data, including goals, transactions, budgets, and personal settings, will be permanently erased from this device. The app will reset to its initial state.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body2,
        ),
        onConfirm: () {
          context.pop(); // close this dialog
          _performAccountDeletion(ref, context);
        },
      ),
    );
  }

  Future<void> _performAccountDeletion(
    WidgetRef ref,
    BuildContext context,
  ) async {
    ref.read(accountDeletionLoadingProvider.notifier).state = true;
    await Future.delayed(Duration(milliseconds: 1200));

    try {
      final db = ref.read(databaseProvider);
      await ref.read(authStateProvider.notifier).logout();
      Log.i('User logged out.');

      await db.clearAllDataAndReset();
      Log.i('Database has been reset successfully.');

      // reset all providers
      ref.read(activeWalletProvider.notifier).reset();

      // Dismiss loading dialog
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      // Navigate to login screen
      if (context.mounted) context.go(Routes.getStarted);
      Log.i('Navigated to login screen.');
    } catch (e) {
      Log.e('Error during account deletion', label: 'delete account');
      // Show error message
      if (context.mounted) {
        toastification.show(
          description: Text('Error deleting account: ${e.toString()}'),
        );
      }
    } finally {
      // Ensure loading state is reset.
      // If the widget is disposed (e.g. due to navigation), autoDispose handles the provider.
      // If still mounted (e.g. error occurred), this hides the overlay.
      ref.read(accountDeletionLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(accountDeletionLoadingProvider);
    // Assuming UserModel has a 'name' property. Adjust if it's different (e.g., 'username').
    final currentUser = ref.read(authStateProvider);

    final userName = currentUser.name;
    final isChallengeMet = useState(false); // Initialize to false

    return Stack(
      children: [
        CustomScaffold(
          context: context,
          title: 'Delete Account',
          showBalance: false,
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warning: Account Deletion is Permanent',
                  style: AppTextStyles.body2.copyWith(color: AppColors.red),
                ),
                const Gap(AppSpacing.spacing12),
                Text(
                  'If you decided proceed, all your application data, including financial records, '
                  'goals, and settings, will be permanently erased from this device. '
                  'This action cannot be undone or irreversible. '
                  'The application will be reset to its initial state, '
                  'and you will be logged out.',
                  style: AppTextStyles.body2,
                ),
                const Gap(AppSpacing.spacing16),
                Text(
                  "Type your user name '$userName' to continue:",
                  style: AppTextStyles.body2,
                ),
                const Gap(AppSpacing.spacing8),
                CustomTextField(
                  hint: 'Enter your username',
                  label: 'Challenge Confirmation',
                  onChanged: (value) {
                    isChallengeMet.value = value == userName;
                  },
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Delete My Account and Erase Data',
                  onPressed: isChallengeMet.value
                      ? () => _showConfirmationSheet(context, ref)
                      : null,
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(150), // Semi-transparent overlay
              child: Center(child: LoadingIndicator(color: Colors.white)),
            ),
          ),
      ],
    );
  }
}
