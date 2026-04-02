import 'package:test/test.dart';
import 'package:tdata/tdata.dart';

void main() {
  // We create one converter instance to use in all tests
  const converter = TDoubleConverter();

  group('TDoubleConverter - fromJson', () {
    test('Successfully converts int type to TDouble', () {
      final result = converter.fromJson(100);
      expect(result.value, 100.0);
    });

    test('Successfully converts double type to TDouble', () {
      final result = converter.fromJson(150.5);
      expect(result.value, 150.5);
    });

    test('Successfully converts String type (containing numbers) to TDouble',
        () {
      final result = converter.fromJson("200.25");
      expect(result.value, 200.25);
    });

    test('MUST throw FormatException if JSON is null', () {
      expect(() => converter.fromJson(null), throwsFormatException);
    });

    test('MUST throw FormatException if JSON contains random string', () {
      expect(() => converter.fromJson("Harga: Gratis"), throwsFormatException);
    });

    test(
        'MUST throw FormatException if JSON contains weird structure (List/Map)',
        () {
      expect(() => converter.fromJson([1, 2, 3]), throwsFormatException);
      expect(() => converter.fromJson({'angka': 1}), throwsFormatException);
    });
  });

  group('TDoubleConverter - toJson', () {
    test('Successfully extracts primitive double value during toJson process',
        () {
      final tDouble = TDouble.safe(99.9);
      final jsonValue = converter.toJson(tDouble);

      // Ensure the output is really pure double (not object/string)
      expect(jsonValue, isA<double>());
      expect(jsonValue, 99.9);
    });
  });
}
