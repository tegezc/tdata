import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TPercentage - Parsing & Constructors', () {
    test('Can parse pure numbers and strings with %', () {
      expect(TPercentage(11).value, 11.0);
      expect(TPercentage(11.5).value, 11.5);

      // Forgiving parser from UI String
      expect(TPercentage("10%").value, 10.0);
      expect(TPercentage(" 15.5 % ").value, 15.5);
    });

    test('fromFraction converts decimal correctly', () {
      final tax = TPercentage.fromFraction(0.11); // 0.11 = 11%
      expect(tax.value, 11.0);
    });
  });

  group('TPercentage - Math & TCurrency Integration', () {
    test('fraction should produce decimal multiplier', () {
      expect(TPercentage(11).fraction, 0.11);
      expect(TPercentage(50).fraction, 0.50);
      expect(TPercentage(100).fraction, 1.0);
    });

    test('calculate() calculates TCurrency deduction accurately', () {
      final hargaKopi = TCurrency(50000); // Rp 50.000
      final ppn = TPercentage(11);        // Tax 11%

      final nominalPajak = ppn.calculate(hargaKopi);

      // 11% of 50,000 is 5,500
      expect(nominalPajak.value, 5500.0);

      // Total Price Simulation:
      final totalBayar = hargaKopi + nominalPajak;
      expect(totalBayar.value, 55500.0);
    });
  });

  group('TPercentage - Display Formatting', () {
    test('toDisplay discards unnecessary decimals', () {
      expect(TPercentage(11.0).toDisplay(), "11%");
      expect(TPercentage(11.50).toDisplay(), "11.5%");
      expect(TPercentage(33.33).toDisplay(), "33.33%");
    });
  });
}