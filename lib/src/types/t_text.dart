/// Wrapper for narrative text (Title, Note, Description).
/// Ensures text is clean from double spaces, illegal characters, and length limits.
extension type const TText._(String value) {
  // ==========================================
  // 1. CONSTRUCTORS
  // ==========================================

  /// [maxLength]: If set, text will be truncated automatically.
  /// [singleLine]: If true, all 'Enter' will be converted to spaces.
  /// [sanitize]: If true, removes double spaces and invisible characters.
  factory TText(
    String text, {
    int? maxLength,
    bool singleLine = false,
    bool sanitize = true,
  }) {
    String processed = text;

    if (sanitize) {
      // 1. Remove spaces at start/end
      processed = processed.trim();
      // 2. Convert double spaces/tabs/excess newlines to single space if sanitize is active
      processed = processed.replaceAll(RegExp(r'\s+'), ' ');
    }

    if (singleLine) {
      // Convert all types of line breaks to single space
      processed = processed.replaceAll(RegExp(r'[\r\n]+'), ' ');
    }

    if (maxLength != null && processed.length > maxLength) {
      processed = processed.substring(0, maxLength).trim();
    }

    return TText._(processed);
  }

  static TText fromJson(dynamic jsonValue) {
    if (jsonValue == null) throw const FormatException('TText.fromJson: null');
    return TText(jsonValue.toString());
  }

  // ==========================================
  // 2. UTILITIES
  // ==========================================

  bool get isEmpty => value.isEmpty;
  bool get isNotEmpty => value.isNotEmpty;
  int get length => value.length;

  /// Truncates text for UI display with ellipsis (...)
  /// Example: "Buy coffee at Star..."
  String toEllipsis(int limit) {
    if (value.length <= limit) return value;
    return '${value.substring(0, limit).trim()}...';
  }

  // ==========================================
  // 3. SERIALIZATION
  // ==========================================

  String toJson() => value;
}
