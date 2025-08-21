import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/chips/custom_currency_chip.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_constants.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/package_info/package_info_provider.dart';
import 'package:pockaw/core/services/url_launcher/url_launcher.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/backup_dialog.dart';
import 'package:pockaw/features/backup_and_restore/presentation/components/restore_dialog.dart';
import 'package:pockaw/features/settings/presentation/components/settings_group_holder.dart';
import 'package:pockaw/features/theme_switcher/presentation/components/theme_mode_switcher.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

part '../components/app_version_info.dart';
part '../components/profile_card.dart';
part '../components/settings_app_info_group.dart';
part '../components/settings_data_group.dart';
part '../components/settings_finance_group.dart';
part '../components/settings_preferences_group.dart';
part '../components/settings_profile_group.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      context: context,
      title: 'Settings',
      showBackButton: true,
      actions: [ThemeModeSwitcher()],
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.spacing20),
        child: Column(
          children: [
            ProfileCard(),
            SettingsProfileGroup(),
            SettingsPreferencesGroup(),
            SettingsFinanceGroup(),
            SettingsDataGroup(),
            SettingsAppInfoGroup(),
            AppVersionInfo(),
          ],
        ),
      ),
    );
  }
}
