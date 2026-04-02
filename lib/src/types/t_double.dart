import 'dart:math' as math;

/// Wrapper for [double] type with zero-cost abstraction.
/// Designed with the "Strict on Parse, Safe on Operation" principle.
extension type const TDouble(double value) {

  // ==========================================
  // 0. DEBUG HELPERS (REMOVED IN RELEASE)
  // ==========================================
  static void _debugFail(String message) {
    assert(false, '[TDouble] $message');
  }
  // ==========================================
  // 1. INTERNAL GUARDS
  // ==========================================

  /// Used ONLY for parsing incoming data (API/JSON)
  static double _strictGuard(double v) {
    if (v.isNaN) throw const FormatException('TDouble cannot be NaN');
    if (v.isInfinite) throw const FormatException('TDouble cannot be infinite');
    return v;
  }

  /// Used for internal math operations to NEVER CRASH the UI
  static double _safeGuard(double v) {
    if (v.isNaN) {
      _debugFail('NaN detected in computation');
      return 0.0;
    } // Most safe fallback
    if (v.isInfinite){
      _debugFail('Infinity detected in computation');
      return v.isNegative ? -double.maxFinite : double.maxFinite;
    }
    return v;
  }

  /// Constructor to explicitly create TDouble safely
  factory TDouble.safe(double value) => TDouble(_safeGuard(value));

  // ==========================================
  // 2. CONSTRUCTORS / PARSERS (BY LAYER)
  // ==========================================

  /// STRICT: For Data Layer / JSON parsing
  static TDouble fromJson(dynamic jsonValue) {
    if (jsonValue == null) {
      throw const FormatException('TDouble.fromJson: jsonValue is null');
    }

    final parsed = jsonValue is num
        ? jsonValue.toDouble()
        : double.tryParse(jsonValue.toString());

    if (parsed == null) {
      throw FormatException('TDouble.fromJson: failed to parse "${jsonValue}"');
    }

    return TDouble(_strictGuard(parsed));
  }

  /// NULLABLE: For Domain / Logic validation
  static TDouble? tryParse(String? source) {
    if (source == null) return null;
    final parsed = double.tryParse(source);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) return null;
    return TDouble(parsed);
  }

  /// SAFE FALLBACK: For UI Input (TextEditingController)
  static TDouble fromInput(String? text, {double fallback = 0.0}) {
    if (text == null || text.trim().isEmpty) {
      return TDouble(_safeGuard(fallback));
    }
    // Handle decimal comma format (e.g., input "1,23" becomes 1.23)
    final normalized = text.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);

    return TDouble(_safeGuard(parsed ?? fallback));
  }

  // ==========================================
  // 3. FORMATTING / DISPLAY
  // ==========================================

  String toDisplay({int decimals = 2}) {
    return value.toStringAsFixed(decimals);
  }

  // ==========================================
  // 4. ARITHMETIC (SAFE)
  // ==========================================

  TDouble operator +(TDouble other) => TDouble(_safeGuard(value + other.value));
  TDouble operator -(TDouble other) => TDouble(_safeGuard(value - other.value));
  TDouble operator *(TDouble other) => TDouble(_safeGuard(value * other.value));

  TDouble operator /(TDouble other) {
    if (other.value == 0) {
      _debugFail('Division by zero detected');
      return const TDouble(0.0);
    }
    return TDouble(_safeGuard(value / other.value));
  }

  // ==========================================
  // 5. UTILITIES & COMPARISON
  // ==========================================

  bool operator >(TDouble other) => value > other.value;
  bool operator <(TDouble other) => value < other.value;
  bool operator >=(TDouble other) => value >= other.value;
  bool operator <=(TDouble other) => value <= other.value;

  bool get isZero => value == 0;
  bool get isPositive => value > 0;
  bool get isNegative => value < 0;

  TDouble get abs => TDouble(_safeGuard(value.abs()));

  TDouble roundTo(int fractionDigits) {
    final mod = math.pow(10, fractionDigits);
    final result = (value * mod).round() / mod;
    return TDouble(_safeGuard(result));
  }

  TDouble clamp(TDouble min, TDouble max) {
    final clamped = value.clamp(min.value, max.value);
    return TDouble(_safeGuard(clamped));
  }
}