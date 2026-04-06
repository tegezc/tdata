import 'package:json_annotation/json_annotation.dart';
import '../types/t_text.dart';

class TTextConverter implements JsonConverter<TText, String> {
  const TTextConverter();

  @override
  TText fromJson(String json) => TText(json);

  @override
  String toJson(TText object) => object.toJson();
}