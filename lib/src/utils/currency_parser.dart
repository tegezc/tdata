import 'package:intl/intl.dart';
import '../types/t_currency.dart';
import 'currency_registry.dart';

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
