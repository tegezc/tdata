import 'package:json_annotation/json_annotation.dart';
import '../types/t_email.dart';

class TEmailConverter implements JsonConverter<TEmail, String> {
  const TEmailConverter();

  @override
  TEmail fromJson(String json) => TEmail(json);

  @override
  String toJson(TEmail object) => object.toJson();
}