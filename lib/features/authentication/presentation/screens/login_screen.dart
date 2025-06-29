import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/database/daos/user_dao.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/data_backup_service/data_backup_service_provider.dart';
import 'package:pockaw/core/services/image_service/domain/image_state.dart';
import 'package:pockaw/core/services/image_service/image_service.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';
import 'package:pockaw/core/services/keyboard_service/virtual_keyboard_service.dart';
import 'package:pockaw/features/theme_switcher/presentation/components/theme_mode_switcher.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';
import 'package:pockaw/core/services/url_launcher/url_launcher.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';
import 'package:pockaw/features/authentication/presentation/components/create_first_wallet_field.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:toastification/toastification.dart';

part '../components/form.dart';
part '../components/logo.dart';
part '../components/login_info.dart';
part '../components/login_image_picker.dart';
part '../components/get_started_description.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeModeProvider);
    final nameField = useTextEditingController();
    final dataBackupService = ref.read(dataBackupServiceProvider);

    return CustomScaffold(
      context: context,
      showBackButton: false,
      showBalance: false,
      actions: [
        CustomIconButton(
          onPressed: () async {
            Toast.show('Starting restore...', type: ToastificationType.info);
            final success = await dataBackupService.restoreData();
            if (success) {
              Toast.show(
                'Data restored successfully!',
                type: ToastificationType.success,
              );
              // Optionally, restart app or refresh all data providers
              // For now, just show toast. User might need to restart for full effect.

              final user = await ref.read(userDaoProvider).getFirstUser();
              if (user == null) {
                Toast.show('Restore failed.', type: ToastificationType.error);
                return;
              }

              final userModel = user.toModel();
              ref.read(authStateProvider.notifier).setUser(userModel);

              if (context.mounted) context.push(Routes.main);
            } else {
              Toast.show(
                'Restore failed or cancelled.',
                type: ToastificationType.error,
              );
            }
          },
          icon: HugeIcons.strokeRoundedDatabaseImport,
          context: context,
          themeMode: themeMode,
        ),
        Gap(AppSpacing.spacing8),
        ThemeModeSwitcher(themeMode: themeMode),
      ],
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            // color: Colors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Form(nameField: nameField)],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spacing20,
                horizontal: AppSpacing.spacing20,
              ),
              child: PrimaryButton(
                label: 'Start Journey',
                onPressed: () {
                  KeyboardService.closeKeyboard();

                  final username = nameField.text.trim();

                  if (username.isEmpty) {
                    toastification.show(
                      description: Text(
                        'Please enter a name.',
                        style: AppTextStyles.body2,
                      ),
                      type: ToastificationType.error,
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                    return;
                  }

                  final user = UserModel(
                    name: username,
                    email:
                        '${username.replaceAll(' ', '').toLowerCase()}@mail.com',
                    profilePicture: ref.read(loginImageProvider).savedPath,
                    createdAt: DateTime.now(),
                  );

                  ref.read(authStateProvider.notifier).setUser(user);
                  context.push(Routes.main);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
