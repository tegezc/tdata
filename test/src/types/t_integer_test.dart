import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TInteger - Parsing & Constructors', () {
    test('fromJson: harus berhasil parse dari berbagai tipe JSON', () {
      // Int murni
      expect(TInteger.fromJson(10).value, 10);
      // Double dari API (forgiving)
      expect(TInteger.fromJson(10.0).value, 10);
      // String int
      expect(TInteger.fromJson("25").value, 25);
      // String double (forgiving)
      expect(TInteger.fromJson("25.9").value, 25);
    });

    test('fromJson: harus melempar FormatException jika input tidak masuk akal', () {
      expect(() => TInteger.fromJson("BukanAngka"), throwsFormatException);
      expect(() => TInteger.fromJson(null), throwsFormatException);
    });

    test('fromInput: harus membersihkan karakter non-digit', () {
      expect(TInteger.fromInput("10 pcs").value, 10);
      expect(TInteger.fromInput("-5 lantai").value, -5);
      expect(TInteger.fromInput("abc").value, 0); // fallback default
    });
  });

  group('TInteger - Arithmetic', () {
    test('Operator pembagian bulat (~/) harus akurat', () {
      final lima = TInteger(5);
      final dua = TInteger(2);

      // 5 dibagi 2 secara integer adalah 2 (bukan 2.5)
      expect((lima ~/ dua).value, 2);
    });

    test('Pembagian dengan nol harus memicu StateError di mode Debug', () {
      final sepuluh = TInteger(10);
      final nol = TInteger(0);

      expect(() => sepuluh ~/ nol, throwsA(isA<AssertionError>()));
    });
  });

  group('TInteger - Utilities', () {
    test('Properti isEven, isOdd, dan abs harus sesuai', () {
      expect(TInteger(2).isEven, isTrue);
      expect(TInteger(3).isOdd, isTrue);
      expect(TInteger(-10).abs.value, 10);
    });
  });
}