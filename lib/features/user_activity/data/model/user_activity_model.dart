import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:pockaw/core/extensions/date_time_extension.dart';

part 'user_activity_model.freezed.dart';
part 'user_activity_model.g.dart';

@freezed
abstract class UserActivityModel with _$UserActivityModel {
  const factory UserActivityModel({
    int? id,
    required int userId,
    int? subjectId,
    required String action,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime timestamp,
    String? appVersion,
    String? deviceModel,
    @Default(true) bool success,
    String? metadata,
  }) = _UserActivityModel;

  factory UserActivityModel.fromJson(Map<String, dynamic> json) =>
      _$UserActivityModelFromJson(json);
}

// Custom JSON (de)serializers for timestamp to produce a human-readable format
// when calling `toJson()` and accept ISO or the human format on `fromJson()`.
DateTime _dateTimeFromJson(String value) {
  // Try ISO parse first
  final iso = DateTime.tryParse(value);
  if (iso != null) return iso;

  // Try the human format used in the app: "d MMMM yyyy hh.mm a" (e.g. 26 June 2025 11.33 AM)
  try {
    return DateFormat('d MMMM yyyy hh.mm a').parse(value);
  } catch (_) {
    // Fallback to parsing as ISO (may throw) to surface malformed values
    return DateTime.parse(value);
  }
}

String _dateTimeToJson(DateTime dt) {
  return dt.toDayMonthYearTime12Hour();
}
