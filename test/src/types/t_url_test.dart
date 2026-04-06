import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TUrl - Constructors & Auto-Correction', () {
    test('Should automatically add https:// if not present', () {
      final url = TUrl("tokopedia.com/sepatu");
      expect(url.value, "https://tokopedia.com/sepatu");
    });

    test('Does not change already valid URL', () {
      final urlHttp = TUrl("http://my-api.com/v1");
      expect(urlHttp.value, "http://my-api.com/v1");
      expect(urlHttp.isSecure, isFalse);

      final urlHttps = TUrl("https://secure.com");
      expect(urlHttps.value, "https://secure.com");
      expect(urlHttps.isSecure, isTrue);
    });

    test('Throws error if autoPrependHttps is false and no protocol', () {
      expect(() => TUrl("google.com", autoPrependHttps: false),
          throwsFormatException);
    });

    test('Throws error if URL is completely invalid (Not a link)', () {
      expect(() => TUrl("ini_bukan_url"), throwsFormatException);
      expect(() => TUrl(""), throwsFormatException);
    });
  });

  group('TUrl - Utilities & Display', () {
    test('Can extract domain (host) correctly', () {
      final url = TUrl("https://www.youtube.com/watch?v=123");
      // Should take only the core domain
      expect(url.domain, "www.youtube.com");
    });

    test('Can get query parameters', () {
      final url = TUrl("https://tdata.com/search?q=flutter&page=1");
      expect(url.queryParameters['q'], 'flutter');
      expect(url.queryParameters['page'], '1');
    });

    test('toDisplay() cleans https and www for UI display', () {
      final url = TUrl("https://www.shopee.co.id/promo-gila");
      expect(url.toDisplay(), "shopee.co.id/promo-gila");
    });
  });
}
