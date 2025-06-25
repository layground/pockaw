import 'package:drift/drift.dart';

/// Extension to convert Drift's [DataClass] instances to a JSON-serializable [Map<String, dynamic>].
///
/// This is useful for exporting database records to a format that can be easily
/// written to a JSON file. It handles basic type conversions like [DateTime] to ISO 8601 strings.
extension DriftModelToJson on DataClass {
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    toJson().forEach((key, value) {
      if (value is DateTime) {
        map[key] = value.toIso8601String(); // Convert DateTime to string
      } else {
        map[key] = value; // Use value directly for other types
      }
    });
    return map;
  }
}
