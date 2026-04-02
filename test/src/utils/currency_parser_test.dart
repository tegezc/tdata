import 'package:test/test.dart';
import 'package:tdata/src/utils/currency_parser.dart';

void main() {
  group('CurrencyParser - Deterministic Parsing', () {
    test('IDR Context: Dot is Thousands', () {
      // 1.500.000 -> 1.5 Million
      expect(
          TCurrencyParser.parseInput("Rp 1.500.000", currencyCode: 'IDR').value,
          1500000.0);
      expect(TCurrencyParser.parseInput("1.500", currencyCode: 'IDR').value,
          1500.0);
    });

    test('USD/SGD/MYR Context: Comma is Thousands, Dot is Decimal', () {
      // 1,500.50 -> One thousand five hundred point five
      expect(
          TCurrencyParser.parseInput("\$ 1,500.50", currencyCode: 'USD').value,
          1500.5);
      expect(TCurrencyParser.parseInput("1,500", currencyCode: 'SGD').value,
          1500.0);
      expect(TCurrencyParser.parseInput("100.25", currencyCode: 'MYR').value,
          100.25);

      // Proof of ambiguity (1.500 in US is read as 1.5)
      expect(
          TCurrencyParser.parseInput("1.500", currencyCode: 'USD').value, 1.5);
    });

    test('Can handle negative numbers (Expenses / Refund)', () {
      expect(TCurrencyParser.parseInput("-Rp 50.000", currencyCode: 'IDR').value,
          -50000.0);
      expect(
          TCurrencyParser.parseInput("-\$ 1,500.50", currencyCode: 'USD').value,
          -1500.5);
    });

    test('Null, empty, or dirty input MUST return fallback value', () {
      expect(TCurrencyParser.parseInput(null, currencyCode: 'IDR').value, 0.0);
      expect(TCurrencyParser.parseInput("", currencyCode: 'IDR').value, 0.0);
      expect(TCurrencyParser.parseInput("   ", currencyCode: 'USD').value, 0.0);

      // If user mischievously enters random letters that fail to be parsed by intl
      expect(
        TCurrencyParser.parseInput("Bukan Uang",
                currencyCode: 'IDR', fallback: 10.0)
            .value,
        10.0,
      );
    });
  });
}
