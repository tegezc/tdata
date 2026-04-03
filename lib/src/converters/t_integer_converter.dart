import 'package:json_annotation/json_annotation.dart';

import '../types/t_int.dart';

/// Converter agar TInteger bisa digunakan otomatis oleh json_serializable / Freezed
class TIntegerConverter implements JsonConverter<TInteger, dynamic> {
  const TIntegerConverter();

  @override
  TInteger fromJson(dynamic json) => TInteger.fromJson(json);

  @override
  dynamic toJson(TInteger object) => object.value;
}