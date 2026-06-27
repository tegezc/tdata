import '../../tdata.dart';

/// Wrapper aman untuk tipe data bilangan bulat (int).
/// Menangani parsing kotor dari API (misalnya angka yang masuk sebagai string "123" atau double "123.0").
///
/// [CURSOR AI HINT]:
/// - STRICT RULE: Use `TInteger` instead of raw `int` for Domain Models.
/// - Best used for quantities, counters, step counts, or IDs.
/// - For JSON serialization in Freezed, annotate the field with `@TIntegerConverter()`.
/// - To get the raw dart int value for loops or math, use `.value`.
extension type const TInteger(int value) {
  TDouble toTDouble() => TDouble.safe(value.toDouble());
  TCurrency toTCurrency() => TCurrency.safe(value.toDouble());

  // ==========================================
  // 0. DEBUG GUARDS
  // ==========================================
  static void _debugFail(String message) {
    assert(false, '[TInteger] $message');
  }

  // Unlike double, Dart 'int' does not have NaN or Infinity.
  // So we don't need complicated _safeGuard here.
  factory TInteger.safe(int value) => TInteger(value);

  // ==========================================
  // 1. CONSTRUCTORS / PARSERS
  // ==========================================

  /// STRICT BUT SMART: For Data Layer / JSON Parser
  static TInteger fromJson(dynamic jsonValue) {
    if (jsonValue == null) {
      throw const FormatException('TInteger.fromJson: jsonValue is null');
    }

    // If JSON sends direct number format (can be int or double)
    if (jsonValue is num) {
      return TInteger(jsonValue.toInt()); // 2.0 will safely become 2
    }

    final stringValue = jsonValue.toString();

    // Scenario 1: Normal parse (example: "10")
    final parsedInt = int.tryParse(stringValue);
    if (parsedInt != null) return TInteger(parsedInt);

    // Scenario 2: Backend sends decimal string (example: "10.5")
    // We catch it as double first, then cut the decimals.
    final parsedDouble = double.tryParse(stringValue);
    if (parsedDouble != null) {
      return TInteger(parsedDouble.toInt());
    }

    throw FormatException('TInteger.fromJson: failed to parse "$jsonValue"');
  }

  /// NULLABLE: For Logic Validation
  static TInteger? tryParse(String? source) {
    if (source == null) return null;
    final parsed = int.tryParse(source);
    return parsed != null ? TInteger(parsed) : null;
  }

  /// SAFE FALLBACK: For UI Input (Example: TextField item quantity)
  static TInteger fromInput(String? text, {int fallback = 0}) {
    if (text == null || text.trim().isEmpty) return TInteger(fallback);

    // Remove all characters except numbers and minus sign
    final cleanedText = text.replaceAll(RegExp(r'[^0-9-]'), '');
    final parsed = int.tryParse(cleanedText);

    return TInteger(parsed ?? fallback);
  }

  // ==========================================
  // 2. ARITHMETIC
  // ==========================================

  TInteger operator +(TInteger other) => TInteger(value + other.value);
  TInteger operator -(TInteger other) => TInteger(value - other.value);
  TInteger operator *(TInteger other) => TInteger(value * other.value);

  /// WARNING: In Dart, operator '/' always returns double.
  /// For TInteger, we use '~/' (Integer Division) which returns int.
  TInteger operator ~/(TInteger other) {
    if (other.value == 0) {
      _debugFail('Division by zero detected');
      return const TInteger(0);
    }
    return TInteger(value ~/ other.value);
  }

  // ==========================================
  // 3. UTILITIES
  // ==========================================

  bool operator >(TInteger other) => value > other.value;
  bool operator <(TInteger other) => value < other.value;
  bool operator >=(TInteger other) => value >= other.value;
  bool operator <=(TInteger other) => value <= other.value;

  bool get isZero => value == 0;
  bool get isPositive => value > 0;
  bool get isNegative => value < 0;
  bool get isEven => value.isEven;
  bool get isOdd => value.isOdd;

  TInteger get abs => TInteger(value.abs());

  String toDisplay() => value.toString();

  // ==========================================
  // SERIALIZATION
  // ==========================================
  /// Returns primitive integer value to save to database
  int toJson() => value;
}
