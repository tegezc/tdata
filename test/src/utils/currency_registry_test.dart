import 'package:test/test.dart';
import 'package:tdata/src/utils/currency_registry.dart';

void main() {
  group('CurrencyRegistry', () {
    test('Must return accurate metadata for registered currencies', () {
      final idr = TCurrencyRegistry.getMeta('IDR');
      expect(idr.locale, 'id_ID');
      expect(idr.decimals, 0);
      expect(idr.symbol, 'Rp ');

      final usd = TCurrencyRegistry.getMeta('USD');
      expect(usd.locale, 'en_US');
      expect(usd.decimals, 2);
    });

    test('Must be immune to case-insensitive (uppercase/lowercase)', () {
      final idrLower = TCurrencyRegistry.getMeta('idr');
      final idrMixed = TCurrencyRegistry.getMeta('iDr');

      expect(idrLower.locale, 'id_ID');
      expect(idrMixed.locale, 'id_ID');
    });

    test('Must return default meta if country code is unknown (Safe Fallback)',
        () {
      // For example, backend sends fictional currency or typo
      final alienCoin = TCurrencyRegistry.getMeta('ALIEN_COIN');

      expect(alienCoin.locale, 'en_US'); // Default that we set
      expect(alienCoin.decimals, 2);
    });
  });
}
