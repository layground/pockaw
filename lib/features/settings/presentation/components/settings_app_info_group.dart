part of '../screens/settings_screen.dart';

final logoutKey = GlobalKey<NavigatorState>();

class SettingsAppInfoGroup extends ConsumerWidget {
  const SettingsAppInfoGroup({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SettingsGroupHolder(
      title: 'App Info',
      settingTiles: [
        MenuTileButton(
          label: 'Privacy Policy',
          icon: HugeIcons.strokeRoundedLegalHammer,
          suffixIcon: HugeIcons.strokeRoundedSquareArrowUpRight,
          onTap: () {
            LinkLauncher.launch(AppConstants.privacyPolicyUrl);
          },
        ),
        MenuTileButton(
          label: 'Terms and Conditions',
          icon: HugeIcons.strokeRoundedFileExport,
          suffixIcon: HugeIcons.strokeRoundedSquareArrowUpRight,
          onTap: () {
            LinkLauncher.launch(AppConstants.termsAndConditionsUrl);
          },
        ),
        MenuTileButton(
          label: 'Report Log File',
          icon: HugeIcons.strokeRoundedFileCorrupt,
          onTap: () => context.openBottomSheet(child: ReportLogFileDialog()),
          onLongPress: () {
            ref.read(userActivityServiceProvider).shareLogActivities();
          },
        ),
        if (kDebugMode)
          MenuTileButton(
            label: 'Developer Portal',
            icon: HugeIcons.strokeRoundedCode,
            onTap: () => context.push(Routes.developerPortal),
          ),
      ],
    );
  }
}
