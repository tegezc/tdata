import 'package:json_annotation/json_annotation.dart';
import '../types/t_password.dart';

class TPasswordConverter implements JsonConverter<TPassword, String> {
  const TPasswordConverter();

  @override
  TPassword fromJson(String json) => TPassword.fromJson(json);

  @override
  String toJson(TPassword object) => object.toJson();
}