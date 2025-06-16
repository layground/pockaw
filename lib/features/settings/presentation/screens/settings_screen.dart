import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/menu_tile_button.dart';
import 'package:pockaw/core/components/chips/custom_currency_chip.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/core/services/package_info/package_info_provider.dart';
import 'package:pockaw/core/services/url_launcher/url_launcher.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:pockaw/features/settings/presentation/components/settings_group_holder.dart';

part '../components/app_version_info.dart';
part '../components/profile_card.dart';
part '../components/settings_app_info_group.dart';
part '../components/settings_finance_group.dart';
part '../components/settings_preferences_group.dart';
part '../components/settings_profile_group.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      title: 'Settings',
      showBackButton: true,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.spacing20),
        child: Column(
          children: [
            ProfileCard(),
            SettingsProfileGroup(),
            SettingsPreferencesGroup(),
            SettingsFinanceGroup(),
            SettingsAppInfoGroup(),
            AppVersionInfo(),
          ],
        ),
      ),
    );
  }
}
