import 't_currency.dart';

/// Wrapper untuk nilai Persentase (Pajak, Diskon, Split Bill).
/// Menghilangkan ambiguitas antara desimal (0.11) dan persentase utuh (11%).
///
/// [CURSOR AI HINT]:
/// - STRICT RULE: Use `TPercentage` for any tax, discount, or proportion fields.
/// - The internal value is stored as the whole percentage (e.g., 11.5 for 11.5%).
/// - MAGIC METHOD: To calculate the tax/discount amount from a price, ALWAYS use `.calculate(baseAmount)`.
///   Example: `final taxAmount = TPercentage(11).calculate(TCurrency(50000));`
/// - To display in UI (e.g., "11%"), ALWAYS use `.toDisplay()`.
/// - For JSON serialization in Freezed, annotate the field with `@TPercentageConverter()`.
extension type const TPercentage._(double value) {
  // ==========================================
  // 1. CONSTRUCTORS & PARSERS
  // ==========================================

  /// Accepts pure number (11) or string with symbol ("11%").
  factory TPercentage(dynamic input) {
    if (input == null) {
      throw const FormatException('TPercentage: input cannot be null');
    }

    if (input is num) {
      return TPercentage._(input.toDouble());
    }

    if (input is String) {
      // Clean string from spaces and % symbol
      final clean = input.replaceAll('%', '').trim();
      final parsed = double.tryParse(clean);
      if (parsed != null) {
        return TPercentage._(parsed);
      }
    }

    throw FormatException('TPercentage: Invalid format -> "$input"');
  }

  /// Creates percentage from fraction/decimal value (Example: 0.11 -> 11%)
  factory TPercentage.fromFraction(double fraction) {
    return TPercentage._(fraction * 100);
  }

  static TPercentage fromJson(dynamic jsonValue) {
    if (jsonValue == null)
      throw const FormatException('TPercentage.fromJson: null');
    return TPercentage(jsonValue);
  }

  static TPercentage? tryParse(dynamic input) {
    try {
      return TPercentage(input);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // 2. MATH & LOGIC (The Killer Features)
  // ==========================================

  /// Returns fraction value (Multiplier).
  /// Very important for manual math operations. (Example: 11% -> 0.11)
  double get fraction => value / 100;

  /// MAGIC FEATURE: Directly calculates money value based on this percentage!
  /// Example: TPercentage(10).calculate(TCurrency(50000)) -> TCurrency(5000)
  TCurrency calculate(TCurrency baseAmount) {
    return baseAmount * fraction;
  }

  TPercentage operator +(TPercentage other) =>
      TPercentage._(value + other.value);
  TPercentage operator -(TPercentage other) =>
      TPercentage._(value - other.value);

  // ==========================================
  // 3. DISPLAY
  // ==========================================

  /// Displays to UI nicely (discards .0 decimals if not needed).
  /// Example: 11.0 -> "11%", 11.5 -> "11.5%"
  String toDisplay() {
    // Show maximum 2 digits after decimal
    String s = value.toStringAsFixed(2);
    // Remove trailing zeros (example 11.50 -> 11.5)
    s = s.replaceAll(RegExp(r'0*$'), '');
    // Remove dot if no decimals left (example 11. -> 11)
    s = s.replaceAll(RegExp(r'\.$'), '');

    return '$s%';
  }

  // ==========================================
  // 4. SERIALIZATION
  // ==========================================

  /// Saves pure number to database (11.5)
  double toJson() => value;
}
