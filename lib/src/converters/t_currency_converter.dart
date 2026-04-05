import 'package:json_annotation/json_annotation.dart';
import '../types/t_currency.dart';

/// Converter so TCurrency can be used automatically by json_serializable / Freezed
class TCurrencyConverter implements JsonConverter<TCurrency, dynamic> {
  const TCurrencyConverter();

  @override
  TCurrency fromJson(dynamic json) => TCurrency.fromJson(json);

  @override
  dynamic toJson(TCurrency object) => object.toJson();
}
