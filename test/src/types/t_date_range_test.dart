import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

import '../test_helper.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment();   // ← ini yang penting
  });
  group('TDateRange - Constructors & Auto-Swap', () {
    test('Harus membalik tanggal secara otomatis jika start > end', () {
      final tgl5 = TDateTime.safe(DateTime(2025, 10, 5));
      final tgl10 = TDateTime.safe(DateTime(2025, 10, 10));

      // User sengaja/tidak sengaja memasukkan input terbalik
      final range = TDateRange(start: tgl10, end: tgl5);

      // Sistem harus pintar membaliknya
      expect(range.start.isSameDay(tgl5), isTrue);
      expect(range.end.isSameDay(tgl10), isTrue);
    });
  });

  group('TDateRange - Presets & Logic', () {
    test('contains() harus akurat mendeteksi tanggal di dalam rentang', () {
      final start = TDateTime.safe(DateTime(2025, 1, 1)).startOfDay;
      final end = TDateTime.safe(DateTime(2025, 1, 5)).startOfDay;
      final range = TDateRange(start: start, end: end);

      final tanggal2 = TDateTime.safe(DateTime(2025, 1, 2));
      final tanggal5 = TDateTime.safe(DateTime(2025, 1, 5, 10, 0)); // Lewat dari startOfDay tanggal 5

      expect(range.contains(tanggal2), isTrue);
      expect(range.contains(tanggal5), isFalse); // Karena end adalah limit batas atas (<)
    });

    test('toDisplay() memformat dengan benar', () {
      final start = TDateTime.safe(DateTime(2025, 10, 1));
      // End adalah awal hari besoknya (2 Okt)
      final end = TDateTime.safe(DateTime(2025, 10, 2));

      final range = TDateRange(start: start, end: end);

      // Tampilan ke user harus "1 Okt 2025", bukan sampai 2 Okt.
      expect(range.toDisplay(), contains("1 Okt"));
    });
  });
}