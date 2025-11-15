import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/utils/logger.dart';

class DeviceInfoUtil {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// get full device info
  Future<BaseDeviceInfo> getDeviceInfo() async {
    return await _deviceInfoPlugin.deviceInfo;
  }

  Future<String> getDeviceModel() async {
    try {
      final deviceInfo = await getDeviceInfo();
      if (deviceInfo is AndroidDeviceInfo) {
        return '${deviceInfo.manufacturer} ${deviceInfo.model}';
      } else if (deviceInfo is IosDeviceInfo) {
        return deviceInfo.utsname.machine;
      } else if (deviceInfo is WebBrowserInfo) {
        return deviceInfo.userAgent ?? 'Web Browser';
      } else if (deviceInfo is MacOsDeviceInfo) {
        return deviceInfo.modelName;
      } else if (deviceInfo is LinuxDeviceInfo) {
        return deviceInfo.prettyName;
      } else {
        Log.d('Unknown device type: $deviceInfo');
        return 'Unknown Device';
      }
    } catch (e) {
      Log.d('Failed to get device info: $e');
      return 'Unknown Device';
    }
  }
}

// create a provider for DeviceInfoUtil
final deviceInfoUtilProvider = Provider<DeviceInfoUtil>((ref) {
  return DeviceInfoUtil();
});
