import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pockaw/core/utils/logger.dart';

/// A service to provide application package information.
class PackageInfoService {
  PackageInfo? _packageInfo;

  /// Initializes the service by fetching package information.
  /// This should be called once, typically at app startup.
  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      Log.i(
        'PackageInfoService initialized: ${_packageInfo?.appName} v${_packageInfo?.version}(${_packageInfo?.buildNumber})',
        label: 'package info',
      );
    } catch (e) {
      Log.e('Failed to initialize PackageInfoService', label: 'package info');
      // Optionally, rethrow or handle more gracefully depending on app requirements
    }
  }

  /// The application name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  String get appName => _packageInfo?.appName ?? 'N/A';

  /// The package name. `bundleIdentifier` on iOS, `packageName` on Android.
  String get packageName => _packageInfo?.packageName ?? 'N/A';

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  String get version => _packageInfo?.version ?? 'N/A';

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  String get buildNumber => _packageInfo?.buildNumber ?? 'N/A';

  /// Returns true if the package information has been loaded.
  bool get isInitialized => _packageInfo != null;
}

/// Provider for the [PackageInfoService].
///
/// It's a singleton instance that should be initialized at app startup.
final packageInfoServiceProvider = Provider<PackageInfoService>((ref) {
  // The service itself doesn't depend on other providers for its creation,
  // but it needs to be initialized.
  // Initialization should happen in main.dart before runApp.
  return PackageInfoService();
});
