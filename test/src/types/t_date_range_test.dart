import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

import '../test_helper.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment(); // ← this is important
  });
  group('TDateRange - Constructors & Auto-Swap', () {
    test('Must automatically reverse dates if start > end', () {
      final tgl5 = TDateTime.safe(DateTime(2025, 10, 5));
      final tgl10 = TDateTime.safe(DateTime(2025, 10, 10));

      // User accidentally/intentionally enters reversed input
      final range = TDateRange(start: tgl10, end: tgl5);

      // System must be smart enough to reverse it
      expect(range.start.isSameDay(tgl5), isTrue);
      expect(range.end.isSameDay(tgl10), isTrue);
    });
  });

  group('TDateRange - Presets & Logic', () {
    test('contains() must accurately detect dates within range', () {
      final start = TDateTime.safe(DateTime(2025, 1, 1)).startOfDay;
      final end = TDateTime.safe(DateTime(2025, 1, 5)).startOfDay;
      final range = TDateRange(start: start, end: end);

      final tanggal2 = TDateTime.safe(DateTime(2025, 1, 2));
      final tanggal5 = TDateTime.safe(
          DateTime(2025, 1, 5, 10, 0)); // Past the startOfDay of date 5

      expect(range.contains(tanggal2), isTrue);
      expect(range.contains(tanggal5),
          isFalse); // Because end is the upper limit (<)
    });

    test('toDisplay() formats correctly', () {
      final start = TDateTime.safe(DateTime(2025, 10, 1));
      // End is the start of tomorrow (2 Oct)
      final end = TDateTime.safe(DateTime(2025, 10, 2));

      final range = TDateRange(start: start, end: end);

      // Display to user should be "1 Oct 2025", not up to 2 Oct.
      expect(range.toDisplay(), contains("1 Okt"));
    });
  });
}
