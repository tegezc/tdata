/// Wrapper for URL text (Web links).
/// Ensures URL is always valid, has protocol (http/https), and safe for UI use.
extension type const TUrl._(String value) {
  // ==========================================
  // 1. CONSTRUCTORS & VALIDATION
  // ==========================================

  /// [autoPrependHttps]: If true, automatically prepends "https://" if user only types "google.com" or "tokopedia.com/barang".
  factory TUrl(String url, {bool autoPrependHttps = true}) {
    var clean = url.trim();
    if (clean.isEmpty) {
      throw const FormatException('TUrl: URL cannot be empty');
    }

    // Automatic correction if protocol is missing
    if (!clean.startsWith(RegExp(r'^http(s)?://'))) {
      if (autoPrependHttps) {
        clean = 'https://$clean';
      } else {
        throw FormatException(
            'TUrl: Must have http:// or https:// protocol -> "$url"');
      }
    }

    // Using built-in Dart parser for structure validation (Host, Domain, etc.)
    final uri = Uri.tryParse(clean);
    if (uri == null || !uri.hasAuthority || uri.host.isEmpty) {
      throw FormatException('TUrl: Invalid URL format -> "$url"');
    }

    if (!uri.host.contains('.')) {
      throw FormatException(
          'TUrl: Domain must have extension (e.g., .com) -> "$url"');
    }

    return TUrl._(clean);
  }

  static TUrl fromJson(dynamic jsonValue) {
    if (jsonValue == null) throw const FormatException('TUrl.fromJson: null');
    // Data from backend is assumed to have protocol, but we still validate
    return TUrl(jsonValue.toString(), autoPrependHttps: false);
  }

  static TUrl? tryParse(String? url, {bool autoPrependHttps = true}) {
    if (url == null || url.trim().isEmpty) return null;
    try {
      return TUrl(url, autoPrependHttps: autoPrependHttps);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // 2. UTILITIES & METADATA
  // ==========================================

  /// Returns built-in Dart Uri object if advanced manipulation is needed
  Uri get asUri => Uri.parse(value);

  /// Gets the main domain name (Example: "tokopedia.com")
  /// Very useful for displaying source icon/logo in UI
  String get domain => asUri.host;

  /// Is this a secure connection (SSL/TLS)?
  bool get isSecure => value.startsWith('https://');

  /// Gets query parameters (Example: ?id=123 -> {id: 123})
  Map<String, String> get queryParameters => asUri.queryParameters;

  // ==========================================
  // 3. DISPLAY
  // ==========================================

  /// Displays clean URL version to UI (Without https:// and www.)
  /// Example: "https://www.google.com/search" -> "google.com/search"
  String toDisplay() {
    var display = value.replaceFirst(RegExp(r'^http(s)?://'), '');
    display = display.replaceFirst(RegExp(r'^www\.'), '');

    // Truncate if too long for UI (maximum 40 characters)
    if (display.length > 40) {
      return '${display.substring(0, 40)}...';
    }
    return display;
  }

  // ==========================================
  // 4. SERIALIZATION
  // ==========================================

  String toJson() => value;
}
