import 'package:json_annotation/json_annotation.dart';
import '../types/t_phone_number.dart';

class TPhoneNumberConverter implements JsonConverter<TPhoneNumber, String> {
  const TPhoneNumberConverter();

  @override
  TPhoneNumber fromJson(String json) => TPhoneNumber.fromJson(json);

  @override
  String toJson(TPhoneNumber object) => object.toJson();
}