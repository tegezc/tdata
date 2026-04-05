import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TDateTime - Constructors', () {
    test('safe() should normalize to UTC', () {
      final local = DateTime(2025, 10, 15, 10);
      final dt = TDateTime.safe(local);

      expect(dt.value.isUtc, true);
    });

    test('now() should be UTC', () {
      final dt = TDateTime.now();

      expect(dt.value.isUtc, true);
    });

    test('utc() should create correct date', () {
      final dt = TDateTime.utc(2025, 10, 15, 12);

      expect(dt.value, DateTime.utc(2025, 10, 15, 12));
    });
  });

  // ==========================================
  // PARSING
  // ==========================================
  group('TDateTime - fromJson', () {
    test('parse ISO string', () {
      final dt = TDateTime.fromJson('2025-10-15T10:00:00Z');

      expect(dt.value.isUtc, true);
      expect(dt.value.year, 2025);
    });

    test('parse timestamp seconds', () {
      final dt = TDateTime.fromJson(1730298600);

      expect(dt.value.year, 2024); // matches UTC
    });

    test('parse timestamp milliseconds', () {
      final dt = TDateTime.fromJson(1730298600000);

      expect(dt.value.year, 2024);
    });

    test('parse stringified timestamp', () {
      final dt = TDateTime.fromJson('1730298600');

      expect(dt.value.isUtc, true);
    });

    test('parse DateTime object', () {
      final raw = DateTime(2025, 10, 15);
      final dt = TDateTime.fromJson(raw);

      expect(dt.value.isUtc, true);
    });

    test('throw on invalid input', () {
      expect(() => TDateTime.fromJson('invalid'), throwsFormatException);
    });
  });

  // ==========================================
  // DATE UTILITIES
  // ==========================================
  group('TDateTime - Date Utilities', () {
    test('startOfDay must reset time to 00:00 based on Local Timezone', () {
      // 1. Create time using Local Time so developers can visualize it easily
      // For example: October 15, 2:30 PM local time
      final dt = TDateTime.safe(DateTime(2025, 10, 15, 14, 30));

      // 2. Run the function
      final result = dt.startOfDay;

      // 3. DON'T compare UTC. Convert result to Local then ensure time is 0.
      final localResult = result.value.toLocal();

      expect(localResult.year, 2025);
      expect(localResult.month, 10);
      expect(localResult.day, 15); // Date remains 15

      // This is the most important: Hour, Minute, Second must be 0
      expect(localResult.hour, 0);
      expect(localResult.minute, 0);
      expect(localResult.second, 0);
      expect(localResult.millisecond, 0);
    });

    test('startOfNextDay normal case (Change Day)', () {
      // 1. Setup using local time for easy debugging
      final dt =
          TDateTime.safe(DateTime(2025, 10, 15, 14, 0)); // Oct 15, 14:00 Local
      final result = dt.startOfNextDay;

      // 2. Check result using local calendar perspective
      final localResult = result.value.toLocal();

      expect(localResult.year, 2025);
      expect(localResult.month, 10);
      expect(localResult.day, 16); // Changed to date 16
      expect(localResult.hour, 0); // Ensure time returns to 00:00
      expect(localResult.minute, 0);
      expect(localResult.second, 0);
    });

    test('startOfNextDay end of month (Change Month)', () {
      // Setup: October 31, 2025, 11:30 PM Local
      final dt = TDateTime.safe(DateTime(2025, 10, 31, 23, 30));
      final result = dt.startOfNextDay;

      final localResult = result.value.toLocal();

      expect(localResult.year, 2025);
      expect(localResult.month, 11); // Changed to month November
      expect(localResult.day, 1); // Changed to date 1
      expect(localResult.hour, 0);
    });

    test('startOfNextDay end of year (Change Year)', () {
      // Setup: December 31, 2025, 3:00 PM Local
      final dt = TDateTime.safe(DateTime(2025, 12, 31, 15, 0));
      final result = dt.startOfNextDay;

      final localResult = result.value.toLocal();

      expect(localResult.year, 2026); // Changed to year 2026
      expect(localResult.month, 1); // Changed to month January
      expect(localResult.day, 1); // Changed to date 1
      expect(localResult.hour, 0);
    });
  });

  // ==========================================
  // COMPARISON
  // ==========================================
  group('TDateTime - Comparison', () {
    final a = TDateTime.utc(2025, 10, 15);
    final b = TDateTime.utc(2025, 10, 16);

    test('>', () => expect(b > a, true));
    test('<', () => expect(a < b, true));
    test('>=', () => expect(a >= a, true));
    test('<=', () => expect(a <= a, true));
  });

  // ==========================================
  // SAME DAY
  // ==========================================
  group('TDateTime - isSameDay', () {
    test(
        'isSameDay must return true for different times on the same day (Local)',
        () {
      // Use regular DateTime local, then wrap with TDateTime.safe
      // This simulates a user entering transactions on their phone directly
      final a = TDateTime.safe(DateTime(2025, 10, 15, 10, 0)); // 10 AM Local
      final b = TDateTime.safe(DateTime(2025, 10, 15, 23, 0)); // 11 PM Local

      // Both occur on date 15 Local, so MUST be true
      expect(a.isSameDay(b), isTrue);
    });

    test(
        'isSameDay must return false if different days even though time difference is small',
        () {
      final malamIni =
          TDateTime.safe(DateTime(2025, 10, 15, 23, 50)); // 11:50 PM
      final besokPagi = TDateTime.safe(DateTime(
          2025, 10, 16, 0, 10)); // 12:10 AM (only 20 minutes difference)

      expect(malamIni.isSameDay(besokPagi), isFalse);
    });
  });

  // ==========================================
  // DATE OPERATIONS
  // ==========================================
  group('TDateTime - Operations', () {
    test('add days', () {
      final dt = TDateTime.utc(2025, 10, 15);
      final result = dt.addDays(5);

      expect(result, TDateTime.utc(2025, 10, 20));
    });

    test('subtract days', () {
      final dt = TDateTime.utc(2025, 10, 15);
      final result = dt.subtractDays(5);

      expect(result, TDateTime.utc(2025, 10, 10));
    });

    test('difference', () {
      final a = TDateTime.utc(2025, 10, 15);
      final b = TDateTime.utc(2025, 10, 10);

      expect(a.difference(b).inDays, 5);
    });
  });

  // ==========================================
  // TIME STATE (DETERMINISTIC)
  // ==========================================
  group('TDateTime - Time State', () {
    final now = DateTime.utc(2025, 10, 15);

    test('isToday true', () {
      final dt = TDateTime.utc(2025, 10, 15);

      expect(dt.isToday(now: now), true);
    });

    test('isPast true', () {
      final dt = TDateTime.utc(2025, 10, 14);

      expect(dt.isPast(now: now), true);
    });

    test('isFuture true', () {
      final dt = TDateTime.utc(2025, 10, 16);

      expect(dt.isFuture(now: now), true);
    });
  });

  // ==========================================
  // SERIALIZATION
  // ==========================================
  group('TDateTime - Serialization', () {
    test('toJson ISO', () {
      final dt = TDateTime.utc(2025, 10, 15);
      final json = dt.toJson();

      expect(json, contains('2025-10-15'));
    });

    test('toEpochMillis', () {
      final dt = TDateTime.utc(1970, 1, 1);
      expect(dt.toEpochMillis(), 0);
    });
  });

  // ==========================================
  // EQUALITY
  // ==========================================
  group('TDateTime - Equality', () {
    test('same moment should be equal', () {
      final a = TDateTime.utc(2025, 10, 15);
      final b = TDateTime.utc(2025, 10, 15);

      expect(a, b);
    });

    test('different moment should not equal', () {
      final a = TDateTime.utc(2025, 10, 15);
      final b = TDateTime.utc(2025, 10, 16);

      expect(a == b, false);
    });
  });

  // ==========================================
  // COPY WITH
  // ==========================================
  group('TDateTime - copyWith', () {
    test('should override selected fields', () {
      final dt = TDateTime.utc(2025, 10, 15);

      final updated = dt.copyWith(day: 20);

      expect(updated, TDateTime.utc(2025, 10, 20));
    });
  });
}
