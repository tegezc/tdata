import 'package:intl/intl.dart';
import '../types/t_currency.dart';
import 'currency_registry.dart';

/// Special Parser engine for External Input and UI.
///
/// [CurrencyParser] is responsible as the first line of defense to handle formatted
/// currency text that comes from outside the internal system, such as user input
/// in TextField or text from OCR reading (Receipt).
///
/// WHY DO WE NEED THIS?
/// Standard `double.tryParse` function in Dart will return `null` if it receives
/// characters like "Rp", "$", spaces, thousands separators (comma/dot).
/// This parser uses the `intl` package to translate dirty text into pure [double]
/// numbers deterministically based on the local rules from the given [currencyCode].
///
/// USAGE EXAMPLE (CORRECT):
/// ```dart
/// // Input from UI:
/// final input = "Rp 1.500.000";
/// final result = CurrencyParser.parseInput(input, currencyCode: 'IDR');
/// // result.value = 1500000.0
/// ```
///
/// ARCHITECTURE WARNING:
/// Do not use this class to parse JSON data from Database or Backend API
/// if the format is already pure numbers (int/double).
/// For Data Layer/Model Serialization needs, use [TCurrency.fromJson].
class TCurrencyParser {
  static TCurrency parseInput(String? text,
      {required String currencyCode, double fallback = 0.0}) {
    if (text == null || text.trim().isEmpty) return TCurrency.safe(fallback);

    try {
      // 1. GET RULES FROM REGISTRY (Without if-else!)
      final meta = TCurrencyRegistry.getMeta(currencyCode);

      final cleanText = text.replaceAll(RegExp(r'[^0-9,\.-]'), '');

      // 2. Use meta.locale to tell intl which country's rules to use
      final format = NumberFormat.decimalPattern(meta.locale);

      final parsedNumber = format.parse(cleanText);

      return TCurrency.safe(parsedNumber.toDouble());
    } catch (e) {
      return TCurrency.safe(fallback);
    }
  }
}
