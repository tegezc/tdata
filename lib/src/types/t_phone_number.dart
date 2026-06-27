import '../utils/phone_registry.dart';

/// Wrapper untuk Nomor Telepon.
/// Otomatis menormalisasi berbagai input kotor menjadi format E.164 (Contoh: +6281234567890).
///
/// [CURSOR AI HINT]:
/// - STRICT RULE: NEVER use raw `String` for phone numbers. ALWAYS use `TPhoneNumber`.
/// - It forgives dirty inputs (e.g., "0812-3456", "(+62) 812"). It will automatically convert them to pure E.164.
/// - For UI Display, use `.toDisplay()` to format it beautifully (e.g., "+62 812-3456-7890").
/// - For UI Privacy, use `.toMasked()`.
/// - For JSON serialization in Freezed, annotate the field with `@TPhoneNumberConverter()`.
extension type const TPhoneNumber._(String value) {
  // ==========================================
  // 1. CONSTRUCTORS & SANITIZATION
  // ==========================================

  /// [defaultIsoCode] uses 2-letter standard (Example: 'ID', 'SG', 'US').
  /// Much more intuitive for developers than memorizing the number '62'.
  factory TPhoneNumber(String phone, {String defaultIsoCode = 'ID'}) {
    final defaultDialCode = PhoneRegistry.getDialCode(defaultIsoCode);
    final normalized = _normalize(phone, defaultDialCode);

    if (!_isValidE164(normalized)) {
      throw FormatException('TPhoneNumber: Invalid format -> "$phone"');
    }

    return TPhoneNumber._(normalized);
  }

  static TPhoneNumber fromJson(dynamic jsonValue) {
    if (jsonValue == null) {
      throw const FormatException('TPhoneNumber.fromJson: null');
    }
    return TPhoneNumber(jsonValue.toString());
  }

  static TPhoneNumber? tryParse(String? phone, {String defaultIsoCode = 'ID'}) {
    if (phone == null || phone.trim().isEmpty) return null;
    try {
      return TPhoneNumber(phone, defaultIsoCode: defaultIsoCode);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // 2. INTERNAL LOGIC
  // ==========================================

  static String _normalize(String rawPhone, String defaultDialCode) {
    String clean = rawPhone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (clean.isEmpty) return '';

    if (clean.startsWith('0')) {
      clean = '+$defaultDialCode${clean.substring(1)}';
    } else if (clean.startsWith(defaultDialCode)) {
      clean = '+$clean';
    } else if (!clean.startsWith('+')) {
      clean = '+$defaultDialCode$clean';
    }

    return clean;
  }

  static bool _isValidE164(String phone) {
    // E.164 = '+' followed by 10-15 digits. (Some small countries can have 8-9 digits, we make it flexible 8-15)
    final regex = RegExp(r'^\+[1-9]\d{7,14}$');
    return regex.hasMatch(phone);
  }

  // ==========================================
  // 3. UTILITIES FROM REGISTRY
  // ==========================================

  /// Get phone code dynamically through Registry
  String get countryCode => PhoneRegistry.extractDialCode(value);

  String get nationalNumber {
    final code = countryCode;
    return value.substring(code.length + 1);
  }

  // ==========================================
  // 4. DISPLAY FORMATTING
  // ==========================================

  String toDisplay() {
    final code = countryCode;
    final national = nationalNumber;

    if (national.length >= 10) {
      final part1 = national.substring(0, 3);
      final part2 = national.substring(3, 7);
      final part3 = national.substring(7);
      return '+$code $part1-$part2-$part3';
    }
    return '+$code $national';
  }

  String toMasked() {
    final code = countryCode;
    final national = nationalNumber;

    if (national.length >= 10) {
      final part1 = national.substring(0, 3);
      final part3 = national.substring(national.length - 4);
      return '+$code $part1-****-$part3';
    }
    return '+$code ****';
  }

  String toJson() => value;
}
