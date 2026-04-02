/// Record type to store currency metadata
typedef CurrencyMeta = ({String locale, int decimals, String symbol});

class TCurrencyRegistry {
  /// Central currency data for your application
  static const Map<String, CurrencyMeta> _data = {
    'IDR': (locale: 'id_ID', decimals: 0, symbol: 'Rp '),
    'SGD': (locale: 'en_SG', decimals: 2, symbol: 'S\$ '),
    'MYR': (locale: 'ms_MY', decimals: 2, symbol: 'RM '),
    'USD': (locale: 'en_US', decimals: 2, symbol: '\$ '),
    'KWD': (locale: 'ar_KW', decimals: 3, symbol: 'د.ك '),
    // Add 180+ other currencies here in the future
  };

  static const CurrencyMeta _defaultMeta =
      (locale: 'en_US', decimals: 2, symbol: '');

  /// Safe function to get metadata.
  /// If code is not found, use default.
  static CurrencyMeta getMeta(String currencyCode) {
    return _data[currencyCode.toUpperCase()] ?? _defaultMeta;
  }
}
