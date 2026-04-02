import 'package:intl/intl.dart';

import '../utils/currency_registry.dart';

/// Wrapper for the currency value.
/// Zero-cost abstraction with support for multi-country formatting.
extension type const TCurrency(double value) {

  // ==========================================
  // 0. DEBUG & GUARDS (Same as TDouble)
  // ==========================================
  static void _debugFail(String message) {
    assert(false, '[TCurrency] $message');
  }

  static double _strictGuard(double v) {
    if (v.isNaN) throw const FormatException('TCurrency cannot be NaN');
    if (v.isInfinite) {
      throw const FormatException('TCurrency cannot be infinite');
    }
    return v;
  }

  static double _safeGuard(double v) {
    if (v.isNaN) {
      _debugFail('NaN detected in computation');
      return 0.0;
    }
    if (v.isInfinite) {
      _debugFail('Infinity detected in computation');
      return v.isNegative ? -double.maxFinite : double.maxFinite;
    }
    return v;
  }

  factory TCurrency.safe(double value) => TCurrency(_safeGuard(value));

  // ==========================================
  // 1. CONSTRUCTORS / PARSERS
  // ==========================================

  static TCurrency fromJson(dynamic jsonValue) {
    if (jsonValue == null) {
      throw const FormatException('TCurrency.fromJson: jsonValue is null');
    }
    final parsed = jsonValue is num
        ? jsonValue.toDouble()
        : double.tryParse(jsonValue.toString());

    if (parsed == null) {
      throw FormatException('TCurrency.fromJson: failed to parse "$jsonValue"');
    }
    return TCurrency(_strictGuard(parsed));
  }

  static TCurrency? tryParse(String? source) {
    if (source == null) return null;
    final parsed = double.tryParse(source);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) return null;
    return TCurrency(parsed);
  }

  // ==========================================
  // 2. CURRENCY FORMATTING (CORE FEATURE)
  // ==========================================

  /// Display currency format (e.g., "Rp 150.000" or "$ 1,500.50")
  String toDisplay(String currencyCode) {
    final meta = TCurrencyRegistry.getMeta(currencyCode);

    final format = NumberFormat.currency(
      locale: meta.locale,
      name: currencyCode.toUpperCase(),
      decimalDigits: meta.decimals,
      customPattern: '${meta.symbol}#,##0${meta.decimals > 0 ? '.00' : ''}',
    );

    return format.format(value);
  }

  /// Display compact currency format (e.g., "Rp 1,5 jt" or "$ 1.5K")
  String toCompact(String currencyCode) {
    final meta = TCurrencyRegistry.getMeta(currencyCode);

    final format = NumberFormat.compactCurrency(
      locale: meta.locale,
      name: currencyCode.toUpperCase(),
      decimalDigits: 0,
      symbol: meta.symbol,
    );
    return format.format(value);
  }

  // ==========================================
  // 3. ARITHMETIC & COMPARISON
  // ==========================================

  TCurrency operator +(TCurrency other) =>
      TCurrency(_safeGuard(value + other.value));
  TCurrency operator -(TCurrency other) =>
      TCurrency(_safeGuard(value - other.value));
  TCurrency operator *(double multiplier) => TCurrency(_safeGuard(value *
      multiplier)); // Currency multiplication is usually with a plain number, e.g., price * quantity

  TCurrency operator /(double divider) {
    if (divider == 0) {
      _debugFail('Division by zero detected');
      return const TCurrency(0.0);
    }
    return TCurrency(_safeGuard(value / divider));
  }

  bool operator >(TCurrency other) => value > other.value;
  bool operator <(TCurrency other) => value < other.value;
  bool operator >=(TCurrency other) => value >= other.value;
  bool operator <=(TCurrency other) => value <= other.value;

  bool get isZero => value == 0;
  bool get isPositive => value > 0;
  bool get isNegative => value < 0;

  TCurrency get abs => TCurrency(_safeGuard(value.abs()));
}
