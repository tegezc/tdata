import 'package:test/test.dart';
import 'package:tdata/tdata.dart';

void main() {
  const converter = TCurrencyConverter();

  group('TCurrencyConverter', () {
    test('fromJson: should convert various JSON types to TCurrency', () {
      expect(converter.fromJson(5000).value, 5000.0);
      expect(converter.fromJson("5000.5").value, 5000.5);
    });

    test('toJson: should return pure double type for database', () {
      final money = TCurrency(7500.0);
      final result = converter.toJson(money);

      expect(result, isA<double>());
      expect(result, 7500.0);
    });

    test('Handling Error: should throw if JSON is null or invalid', () {
      expect(() => converter.fromJson(null), throwsFormatException);
      expect(() => converter.fromJson("Gratis"), throwsFormatException);
    });
  });
}
