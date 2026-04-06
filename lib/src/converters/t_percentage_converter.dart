import 'package:json_annotation/json_annotation.dart';
import '../types/t_percentage.dart';

class TPercentageConverter implements JsonConverter<TPercentage, dynamic> {
  const TPercentageConverter();

  @override
  TPercentage fromJson(dynamic json) => TPercentage.fromJson(json);

  @override
  dynamic toJson(TPercentage object) => object.toJson();
}