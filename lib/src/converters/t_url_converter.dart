import 'package:json_annotation/json_annotation.dart';
import '../types/t_url.dart';

class TUrlConverter implements JsonConverter<TUrl, String> {
  const TUrlConverter();

  @override
  TUrl fromJson(String json) => TUrl.fromJson(json);

  @override
  String toJson(TUrl object) => object.toJson();
}