import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/popup_extension.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/image_service/domain/image_state.dart';
import 'package:pockaw/core/services/image_service/image_service.dart';
import 'package:pockaw/core/services/keyboard_service/virtual_keyboard_service.dart';
import 'package:pockaw/core/services/url_launcher/url_launcher.dart';
import 'package:pockaw/features/authentication/presentation/components/create_first_wallet_field.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/user_form_provider.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/restore_dialog.dart';
import 'package:pockaw/features/image_picker/presentation/screens/image_picker_dialog.dart';
import 'package:pockaw/features/settings/presentation/components/report_log_file_dialog.dart';
import 'package:pockaw/features/theme_switcher/presentation/components/theme_mode_switcher.dart';

part '../components/form.dart';
part '../components/get_started_description.dart';
part '../components/login_image_picker.dart';
part '../components/login_info.dart';
part '../components/logo.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final nameField = useTextEditingController();

    void restoreData() {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (dialogContext) => CustomBottomSheet(
          title: 'Restore Data',
          child: RestoreDialog(
            onSuccess: () async {
              await Future.delayed(Duration(milliseconds: 1500));

              if (context.mounted) {
                dialogContext.pop();
                context.replace(Routes.main);
              }
            },
          ),
        ),
      );
    }

    return CustomScaffold(
      context: context,
      showBackButton: false,
      showBalance: false,
      actions: [
        CustomIconButton(
          context,
          onPressed: () => context.openBottomSheet(
            child: ReportLogFileDialog(),
          ),
          icon: HugeIcons.strokeRoundedAlertDiamond,
          themeMode: context.themeMode,
        ),
        Gap(AppSpacing.spacing8),
        CustomIconButton(
          context,
          onPressed: restoreData,
          icon: HugeIcons.strokeRoundedDatabaseImport,
          themeMode: context.themeMode,
        ),
        Gap(AppSpacing.spacing8),
        ThemeModeSwitcher(),
      ],
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            // color: Colors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(nameField: nameField),
          ),
          PrimaryButton(
            label: 'Start Journey',
            isLoading: ref.watch(startJourneyProvider).isLoading,
            onPressed: () async {
              final profilePicture = ref.read(loginImageProvider).savedPath;
              await ref
                  .read(startJourneyProvider.notifier)
                  .startJourney(
                    context: context,
                    username: nameField.text,
                    profilePicture: profilePicture,
                  );
            },
          ).floatingBottomContained,
        ],
      ),
    );
  }
}
