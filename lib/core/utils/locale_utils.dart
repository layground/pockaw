import 'package:device_region/device_region.dart';
import 'package:flutter/material.dart';
import 'package:pockaw/core/utils/logger.dart';

/// Gets the device's 2-letter ISO country code.
///
/// e.g., "en_US" -> "US"
/// e.g., "id_ID" -> "ID"
/// e.g., "fr_FR" -> "FR"
String? getDeviceCountryCode(BuildContext context) {
  // Get the full locale string (e.g., "en_US")
  // `Platform.localeName` is the most common way.
  final locale = Localizations.localeOf(context);
  final country = locale.countryCode;
  Log.d(locale.languageCode, label: 'language');
  Log.d(locale.toString(), label: 'device country');
  if (country != null) {
    return country.toUpperCase();
  }

  // If there's no country code (e.g., just "en"), we can't determine it.
  return null;
}

/// Get device region
Future<String?> getDeviceRegion() async {
  final result = await DeviceRegion.getSIMCountryCode();
  Log.d(result?.toUpperCase(), label: 'device region');
  return result?.toUpperCase();
}
