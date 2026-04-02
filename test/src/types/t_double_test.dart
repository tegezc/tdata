import 'package:flutter_test/flutter_test.dart';
import 'package:tdata/tdata.dart';

void main() {
  group('TDouble - Parsing & Constructors', () {
    test('fromJson harus berhasil parse angka valid', () {
      expect(TDouble.fromJson(150.5).value, 150.5);
      expect(TDouble.fromJson("150.5").value, 150.5);
    });

    test('fromJson harus throw FormatException jika format salah', () {
      expect(() => TDouble.fromJson("Bukan Angka"), throwsFormatException);
      expect(() => TDouble.fromJson(null), throwsFormatException);
    });

    test('fromInput harus mengembalikan fallback jika input kacau', () {
      expect(TDouble.fromInput("Kacau").value, 0.0);
      expect(TDouble.fromInput("Kacau", fallback: 10.0).value, 10.0);
    });

    test('fromInput harus bisa handle koma desimal', () {
      expect(TDouble.fromInput("1,23").value, 1.23); // Koma menjadi titik
    });
  });

  group('TDouble - Arithmetic & Guards', () {
    test('Penjumlahan berjalan normal', () {
      final a = TDouble.safe(10.5);
      final b = TDouble.safe(2.0);
      expect((a + b).value, 12.5);
    });

    test('Pembagian dengan nol harus memicu _debugFail (StateError) di mode Debug', () {
      final a = TDouble.safe(10.0);
      final b = TDouble.safe(0.0);

      // Karena kita menjalankan test di environment Debug, assert akan aktif
      // dan melemparkan StateError dari _debugFail yang kita buat.
      expect(() => a / b, throwsA(isA<AssertionError>()));
    });
  });

  group('TDouble - Formatting', () {
    test('toDisplay menghasilkan format string yang benar', () {
      final a = TDouble.safe(1500.5);
      expect(a.toDisplay(decimals: 2), "1500.50");
      expect(a.toDisplay(decimals: 0), "1501"); // Otomatis dibulatkan oleh Dart
    });
  });
}