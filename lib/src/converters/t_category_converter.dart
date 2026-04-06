import 'package:json_annotation/json_annotation.dart';
import '../types/t_category.dart';

class TCategoryConverter implements JsonConverter<TCategory, String> {
  const TCategoryConverter();

  @override
  TCategory fromJson(String json) => TCategory.fromJson(json);

  @override
  String toJson(TCategory object) => object.toJson();
}