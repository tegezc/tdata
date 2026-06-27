/// Wrapper untuk teks Email.
/// Melakukan auto-sanitization (lowercase & hapus spasi) serta memvalidasi format standar.
///
/// [CURSOR AI HINT]:
/// - STRICT RULE: NEVER use raw `String` for email fields. ALWAYS use `TEmail`.
/// - When capturing input from a form, use `TEmail.tryParse(input)`. If it returns null, show a validation error.
/// - For UI Privacy (e.g., Profile screen or forgot password hint), ALWAYS use `.toMasked()` (returns "use***@gmail.com").
/// - For JSON serialization in Freezed, annotate the field with `@TEmailConverter()`.
extension type const TEmail._(String value) {
  // Industry-standard regex for email validation
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // ==========================================
  // 1. CONSTRUCTORS & VALIDATOR
  // ==========================================

  /// Main Constructor: Automatically cleans (trim) and converts to lowercase.
  /// Will throw FormatException if email is invalid.
  factory TEmail(String email) {
    final normalized = email.trim().toLowerCase();

    if (!_emailRegex.hasMatch(normalized)) {
      throw FormatException('TEmail: Invalid email format -> "$email"');
    }

    return TEmail._(normalized);
  }

  /// Strict parser for Data Layer (JSON)
  static TEmail fromJson(dynamic jsonValue) {
    if (jsonValue == null) {
      throw const FormatException('TEmail.fromJson: jsonValue is null');
    }
    if (jsonValue is! String) {
      throw FormatException('TEmail.fromJson: value must be a String');
    }
    return TEmail(jsonValue); // Uses factory above for validation
  }

  /// Safe parser for UI/Form Validation (Returns null if fails)
  static TEmail? tryParse(String? email) {
    if (email == null || email.trim().isEmpty) return null;

    final normalized = email.trim().toLowerCase();
    if (!_emailRegex.hasMatch(normalized)) return null;

    return TEmail._(normalized);
  }

  // ==========================================
  // 2. UTILITIES
  // ==========================================

  /// Get username part (before @)
  String get username => value.split('@').first;

  /// Get domain part (after @)
  String get domain => value.split('@').last;

  /// Is this a Gmail email?
  bool get isGmail => domain == 'gmail.com';

  // ==========================================
  // 3. DISPLAY & SECURITY
  // ==========================================

  /// Censor email for privacy in UI (Example: "sup***@gmail.com")
  /// Very useful for "Reset Password" or "Profile" screens
  String toMasked() {
    final parts = value.split('@');
    final user = parts[0];
    final dom = parts[1];

    if (user.length <= 3) {
      // If username is very short (e.g., a@gmail.com), mask partially
      return '${user[0]}***@$dom';
    }

    // Take first 3 letters, rest masked with 3 asterisks
    final visibleUser = user.substring(0, 3);
    return '$visibleUser***@$dom';
  }

  // ==========================================
  // 4. SERIALIZATION
  // ==========================================

  String toJson() => value;
}
