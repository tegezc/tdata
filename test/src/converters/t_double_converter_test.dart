import 'package:flutter_test/flutter_test.dart';
import 'package:tdata/tdata.dart';

void main() {
  // Kita buat satu instance converter untuk dipakai di semua test
  const converter = TDoubleConverter();

  group('TDoubleConverter - fromJson', () {
    test('Berhasil mengubah tipe int menjadi TDouble', () {
      final result = converter.fromJson(100);
      expect(result.value, 100.0);
    });

    test('Berhasil mengubah tipe double menjadi TDouble', () {
      final result = converter.fromJson(150.5);
      expect(result.value, 150.5);
    });

    test('Berhasil mengubah tipe String (berisi angka) menjadi TDouble', () {
      final result = converter.fromJson("200.25");
      expect(result.value, 200.25);
    });

    test('HARUS melempar FormatException jika JSON adalah null', () {
      expect(() => converter.fromJson(null), throwsFormatException);
    });

    test('HARUS melempar FormatException jika JSON berisi string acak', () {
      expect(() => converter.fromJson("Harga: Gratis"), throwsFormatException);
    });

    test('HARUS melempar FormatException jika JSON berisi struktur aneh (List/Map)', () {
      expect(() => converter.fromJson([1, 2, 3]), throwsFormatException);
      expect(() => converter.fromJson({'angka': 1}), throwsFormatException);
    });
  });

  group('TDoubleConverter - toJson', () {
    test('Berhasil mengekstrak nilai primitive double saat proses toJson', () {
      final tDouble = TDouble.safe(99.9);
      final jsonValue = converter.toJson(tDouble);

      // Memastikan outputnya benar-benar double murni (bukan object/string)
      expect(jsonValue, isA<double>());
      expect(jsonValue, 99.9);
    });
  });
}