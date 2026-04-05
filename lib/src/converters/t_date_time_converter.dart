import 'package:json_annotation/json_annotation.dart';
import '../types/t_date_time.dart';

/// Converter so TDateTime can be used automatically by json_serializable
class TDateTimeConverter implements JsonConverter<TDateTime, dynamic> {
  const TDateTimeConverter();

  @override
  TDateTime fromJson(dynamic json) => TDateTime.fromJson(json);

  @override
  dynamic toJson(TDateTime object) {
    return object.toJson();
  }
}
