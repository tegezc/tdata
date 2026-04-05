/// File: lib/src/converters/t_double_converter.dart
library;
import 'package:json_annotation/json_annotation.dart';
import '../types/t_double.dart';

/// Converter so TDouble can be used automatically by json_serializable / Freezed
class TDoubleConverter implements JsonConverter<TDouble, dynamic> {
  const TDoubleConverter();

  @override
  TDouble fromJson(dynamic json) {
    // Call our strict parsing method.
    // If the API sends a weird format, this will throw a FormatException.
    return TDouble.fromJson(json);
  }

  @override
  dynamic toJson(TDouble object) {
    // Return the primitive double value when sending to Backend/Firebase
    return object.toJson();
  }
}