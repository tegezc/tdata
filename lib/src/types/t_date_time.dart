import 'package:intl/intl.dart';

/// Production-grade DateTime wrapper.
// /// Memastikan semua waktu disimpan secara absolut dalam format UTC untuk mencegah bug zona waktu.
// ///
// /// [CURSOR AI HINT]:
// /// - STRICT RULE: NEVER use raw `DateTime` for entity models. ALWAYS use `TDateTime`.
// /// - The internal value is ALWAYS in UTC.
// /// - MAGIC FACTORY: When capturing user input from UI (Local Time), wrap it with `TDateTime.safe(localDateTime)`.
// /// - For UI Display (Text widgets), ALWAYS use `.toDisplayDate()` or `.toDisplayDateTime()`. It will automatically convert to the user's Local Time.
// /// - Use helpers like `.startOfDay`, `.endOfDay`, `.startOfNextMonth` for accurate calendar calculations.
// /// - For JSON serialization in Freezed, ALWAYS annotate the field with `@TDateTimeConverter()`.
extension type const TDateTime(DateTime value) {
  // ==========================================
  // 1. CONSTRUCTORS
  // ==========================================

  /// Always normalize to UTC
  factory TDateTime.safe(DateTime value) => TDateTime(value.toUtc());

  factory TDateTime.now() => TDateTime(DateTime.now().toUtc());

  factory TDateTime.utc(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  ]) {
    return TDateTime(DateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
    ));
  }

  // ==========================================
  // 2. INTERNAL HELPERS
  // ==========================================

  static TDateTime _fromTimestamp(int timestamp) {
    // > 10 digit = milliseconds
    final isMilliseconds = timestamp > 100000000000;

    final ms = isMilliseconds ? timestamp : timestamp * 1000;

    return TDateTime(
      DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true),
    );
  }

  // ==========================================
  // 3. PARSER (API SAFE)
  // ==========================================

  static TDateTime fromJson(dynamic jsonValue) {
    if (jsonValue == null) {
      throw const FormatException('TDateTime.fromJson: null value');
    }

    if (jsonValue is DateTime) {
      return TDateTime(jsonValue.toUtc());
    }

    if (jsonValue is num) {
      return _fromTimestamp(jsonValue.toInt());
    }

    if (jsonValue is String) {
      final parsedInt = int.tryParse(jsonValue);
      if (parsedInt != null) {
        return _fromTimestamp(parsedInt);
      }

      final parsedDate = DateTime.tryParse(jsonValue);
      if (parsedDate != null) {
        return TDateTime(parsedDate.toUtc());
      }
    }

    throw FormatException('TDateTime.fromJson: invalid value "$jsonValue"');
  }

  // ==========================================
  // 4. DATABASE UTILITIES
  // ==========================================

  /// Get 00:00:00 according to user's local timezone,
  /// then return as TDateTime (UTC) for safe Firebase queries.
  TDateTime get startOfDay {
    final local = value.toLocal(); // 1. See user's local time

    // 2. Create 00:00:00 in that local timezone
    final localStart = DateTime(local.year, local.month, local.day);

    // 3. Save back as TDateTime (automatically converted to UTC by constructor)
    return TDateTime.safe(localStart);
  }

  /// startOfDay + 1 day (Safe for DST)
  TDateTime get startOfNextDay {
    final local = value.toLocal();
    // Adding days at Local Time level is much more robust against Daylight Saving Time (DST) changes
    final localNext = DateTime(local.year, local.month, local.day + 1);

    return TDateTime.safe(localNext);
  }

  // ==========================================
  // 5. COMPARISON
  // ==========================================

  bool operator >(TDateTime other) => value.isAfter(other.value);

  bool operator <(TDateTime other) => value.isBefore(other.value);

  bool operator >=(TDateTime other) =>
      value.isAfter(other.value) || value.isAtSameMomentAs(other.value);

  bool operator <=(TDateTime other) =>
      value.isBefore(other.value) || value.isAtSameMomentAs(other.value);

  /// Compare by calendar day (LOCAL)
  bool isSameDay(TDateTime other) {
    final localThis = value.toLocal();
    final localOther = other.value.toLocal();

    return localThis.year == localOther.year &&
        localThis.month == localOther.month &&
        localThis.day == localOther.day;
  }

  // ==========================================
  // 6. DATE OPERATIONS
  // ==========================================

  TDateTime add(Duration duration) => TDateTime(value.add(duration));

  TDateTime subtract(Duration duration) => TDateTime(value.subtract(duration));

  Duration difference(TDateTime other) => value.difference(other.value);

  TDateTime addDays(int days) => add(Duration(days: days));

  TDateTime subtractDays(int days) => subtract(Duration(days: days));

  // ==========================================
  // 7. TIME STATE (DETERMINISTIC)
  // ==========================================

  bool isToday({DateTime? now}) {
    final current = (now ?? DateTime.now()).toUtc();
    return isSameDay(TDateTime(current));
  }

  bool isPast({DateTime? now}) {
    final current = (now ?? DateTime.now()).toUtc();
    return value.isBefore(current);
  }

  bool isFuture({DateTime? now}) {
    final current = (now ?? DateTime.now()).toUtc();
    return value.isAfter(current);
  }

  // ==========================================
  // 8. SERIALIZATION
  // ==========================================

  /// ISO 8601 (UTC)
  String toJson() => value.toUtc().toIso8601String();

  int toEpochMillis() => value.toUtc().millisecondsSinceEpoch;

  // ==========================================
  // 9. COPY
  // ==========================================

  TDateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
  }) {
    final v = value.toUtc();

    return TDateTime.utc(
      year ?? v.year,
      month ?? v.month,
      day ?? v.day,
      hour ?? v.hour,
      minute ?? v.minute,
      second ?? v.second,
      millisecond ?? v.millisecond,
    );
  }

  // ==========================================
  // 10. DISPLAY (LOCAL)
  // ==========================================

  String toDisplayDate({String locale = 'id_ID'}) {
    return DateFormat('dd MMM yyyy', locale).format(value.toLocal());
  }

  String toDisplayTime({String locale = 'id_ID'}) {
    return DateFormat('HH:mm', locale).format(value.toLocal());
  }

  String toDisplayFull({String locale = 'id_ID'}) {
    return DateFormat('dd MMM yyyy, HH:mm', locale).format(value.toLocal());
  }
}
