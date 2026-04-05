/// Enum for UI strength indicator (Example: Red, yellow, green bar)
enum PasswordStrength { weak, medium, strong }

/// Wrapper for password text.
/// Designed for security, strength evaluation, and preventing log leaks.
extension type const TPassword._(String value) {
  // ==========================================
  // 1. CONSTRUCTORS
  // ==========================================

  /// Basic constructor. Only prevents empty or too short passwords (absolute standard).
  /// We do NOT enforce symbols/numbers here so legacy users can still Login.
  factory TPassword(String password) {
    if (password.isEmpty) {
      throw const FormatException('TPassword: Tidak boleh kosong');
    }
    // Absolute minimum limit to prevent trivial brute-force
    if (password.length < 6) {
      throw const FormatException('TPassword: Minimal 6 karakter');
    }

    // WARNING: We do NOT perform .trim() on password.
    return TPassword._(password);
  }

  static TPassword fromJson(dynamic jsonValue) {
    if (jsonValue == null)
      throw const FormatException('TPassword.fromJson: null');
    return TPassword(jsonValue.toString());
  }

  static TPassword? tryParse(String? password) {
    if (password == null || password.isEmpty || password.length < 6)
      return null;
    return TPassword._(password);
  }

  // ==========================================
  // 2. STRENGTH EVALUATION (REGEXP)
  // ==========================================

  bool get hasMinLength => value.length >= 8; // Ideally 8 and above
  bool get hasUppercase => value.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => value.contains(RegExp(r'[a-z]'));
  bool get hasNumber => value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar =>
      value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_]'));

  /// Calculate password strength score for UI feedback
  PasswordStrength get strength {
    int score = 0;

    if (hasMinLength) score++;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasNumber) score++;
    if (hasSpecialChar) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  /// Helper for registration form: Does password meet the highest standard?
  bool get isStrongEnoughForRegistration => strength == PasswordStrength.strong;

  // ==========================================
  // 3. SECURITY & DISPLAY
  // ==========================================

  /// Use this only if you absolutely must print to UI or Console Log.
  /// Output: "********" (Matches the length of original characters)
  String toObscured() => '*' * value.length;

  // ==========================================
  // 4. SERIALIZATION
  // ==========================================

  /// Original value only released when sent to Backend API
  String toJson() => value;
}
