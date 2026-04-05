import 't_date_time.dart';

/// Wraps two TDateTime (start and end) for filtering and reporting purposes.
/// Very safe: Automatically fixes if dates are reversed.
class TDateRange {
  final TDateTime start;
  final TDateTime end;

  // Private constructor
  const TDateRange._(this.start, this.end);

  // ==========================================
  // 1. CONSTRUCTORS & VALIDATION
  // ==========================================

  /// Smart constructor: If user/UI accidentally enters start date greater than end date, system will AUTOMATICALLY swap them.
  factory TDateRange({required TDateTime start, required TDateTime end}) {
    if (start > end) {
      return TDateRange._(end, start);
    }
    return TDateRange._(start, end);
  }

  static TDateRange fromJson(Map<String, dynamic>? json) {
    if (json == null) throw const FormatException('TDateRange.fromJson: null');

    try {
      final start = TDateTime.fromJson(json['start']);
      final end = TDateTime.fromJson(json['end']);
      return TDateRange(start: start, end: end);
    } catch (e) {
      throw FormatException('TDateRange.fromJson: invalid format -> $e');
    }
  }

  // ==========================================
  // 2. SMART PRESETS (Very useful for UI Filter)
  // ==========================================

  /// Preset: Today (00:00 to tomorrow 00:00)
  factory TDateRange.today() {
    final now = TDateTime.now();
    return TDateRange._(now.startOfDay, now.startOfNextDay);
  }

  /// Preset: Last 7 Days (including today)
  factory TDateRange.last7Days() {
    final now = TDateTime.now();
    final start = now.subtractDays(6).startOfDay;
    return TDateRange._(start, now.startOfNextDay);
  }

  /// Preset: This Month (Date 1 to start of next month)
  factory TDateRange.thisMonth() {
    final localNow = DateTime.now().toLocal();
    final startOfMonth =
        TDateTime.safe(DateTime(localNow.year, localNow.month, 1));
    final startOfNextMonth =
        TDateTime.safe(DateTime(localNow.year, localNow.month + 1, 1));

    return TDateRange._(startOfMonth, startOfNextMonth);
  }

  // ==========================================
  // 3. UTILITIES & LOGIC
  // ==========================================

  /// Check if a date (target) is within this range
  bool contains(TDateTime target) {
    // Inclusive range (>= start and < end)
    // Using '< end' logic because end is usually startOfNextDay
    return (target >= start) && (target < end);
  }

  /// Calculate range duration in days
  int get durationInDays {
    return end.difference(start).inDays;
  }

  // ==========================================
  // 4. DISPLAY FORMATTING
  // ==========================================

  /// Example output: "12 Oct 2025 - 15 Oct 2025"
  /// Smart: If month/year are the same, could be shortened later
  String toDisplay({String locale = 'id_ID'}) {
    // If range is only 1 day, display only 1 date
    if (durationInDays <= 1) {
      return start.toDisplayDate(locale: locale);
    }

    // Because 'end' is startOfNextDay (tomorrow at 00:00),
    // For display purposes to user, we subtract 1 day to make sense.
    // For example, range (1 Oct - 2 Oct 00:00) is displayed as "1 Oct 2025"
    final displayEnd = end.subtractDays(1);

    return '${start.toDisplayDate(locale: locale)} - ${displayEnd.toDisplayDate(locale: locale)}';
  }

  // ==========================================
  // 5. SERIALIZATION & EQUALITY
  // ==========================================

  Map<String, dynamic> toJson() {
    return {
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TDateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
