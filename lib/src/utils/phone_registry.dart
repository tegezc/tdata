typedef PhoneMeta = ({String isoCode, String dialCode});

class PhoneRegistry {
  /// Central phone code data (Can be expanded to 180+ countries)
  static const List<PhoneMeta> _data = [
    (isoCode: 'ID', dialCode: '62'), // Indonesia
    (isoCode: 'SG', dialCode: '65'), // Singapore
    (isoCode: 'MY', dialCode: '60'), // Malaysia
    (isoCode: 'US', dialCode: '1'), // United States / Canada
    (isoCode: 'GB', dialCode: '44'), // England
    (isoCode: 'JP', dialCode: '81'), // Japan
  ];

  static const PhoneMeta _defaultMeta = (isoCode: 'ID', dialCode: '62');

  /// Get dialCode based on ISO code (Example: 'ID' -> '62')
  static String getDialCode(String isoCode) {
    final meta = _data.firstWhere(
      (m) => m.isoCode == isoCode.toUpperCase(),
      orElse: () => _defaultMeta,
    );
    return meta.dialCode;
  }

  /// Extract country code from complete E.164 number (Example: "+6591234567" -> "65")
  static String extractDialCode(String e164Phone) {
    // Find all matching prefixes in registry
    final matches =
        _data.where((m) => e164Phone.startsWith('+${m.dialCode}')).toList();

    if (matches.isNotEmpty) {
      // If there are conflicting prefixes (e.g., +1 and +124), take the most specific (longest) dialCode
      matches.sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));
      return matches.first.dialCode;
    }

    // System fallback if country is not yet registered in registry (Guess first 2 digits)
    if (e164Phone.length >= 3) {
      return e164Phone.substring(1, 3);
    }

    return _defaultMeta.dialCode;
  }
}
