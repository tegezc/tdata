import 'package:test/test.dart';
import 'package:tdata/tdata.dart';

void main() {
  group('TCurrency - Regional Formatting', () {
    test('IDR (Rupiah) format should not have decimals', () {
      final money = TCurrency(15000.75);
      // Automatic rounding up if decimals are removed
      expect(money.toDisplay('IDR'), contains('Rp 15.001'));
    });

    test('SGD and MYR format must have 2 decimals', () {
      final money = TCurrency(15000.5);
      expect(money.toDisplay('SGD'), contains('15,000.50'));
      expect(money.toDisplay('MYR'), contains('15,000.50'));
    });

    test('toCompact should work for large amounts', () {
      expect(
        TCurrency(1500000).toCompact('IDR'),
        matches(RegExp(r'1,5\s*jt')),
      );
      expect(TCurrency(1500000).toCompact('USD'), contains('1.5M'));
    });
  });

  group('TCurrency - Arithmetic', () {
    test('Mathematical operators must return TCurrency type', () {
      final a = TCurrency(1000);
      final b = TCurrency(500);

      expect(a + b, isA<TCurrency>());
      expect((a + b).value, 1500.0);
      expect((a * 2).value, 2000.0);
    });

    test('Division by zero should trigger StateError in Debug', () {
      final a = TCurrency(1000);
      expect(() => a / 0, throwsA(isA<AssertionError>()));
    });
  });
}
