import 'package:json_annotation/json_annotation.dart';
import '../types/t_date_range.dart';

/// Converter agar TDateRange otomatis menjadi JSON Map:
/// { "start": "2025-10-01T...", "end": "2025-11-01T..." }
class TDateRangeConverter implements JsonConverter<TDateRange, Map<String, dynamic>> {
  const TDateRangeConverter();

  @override
  TDateRange fromJson(Map<String, dynamic> json) => TDateRange.fromJson(json);

  @override
  Map<String, dynamic> toJson(TDateRange object) => object.toJson();
}