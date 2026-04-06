import 'package:json_annotation/json_annotation.dart';
import '../types/t_coordinate.dart';

class TCoordinateConverter implements JsonConverter<TCoordinate, Map<String, dynamic>> {
  const TCoordinateConverter();

  @override
  TCoordinate fromJson(Map<String, dynamic> json) => TCoordinate.fromJson(json);

  @override
  Map<String, dynamic> toJson(TCoordinate object) => object.toJson();
}