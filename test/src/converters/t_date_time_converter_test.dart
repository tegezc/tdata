import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  const converter = TDateTimeConverter();

  test('toJson: Must produce UTC String format (ISO 8601)', () {
    // We create a date in local timezone, then convert it
    final localTime = TDateTime.safe(DateTime(2025, 10, 30, 12, 0).toLocal());
    final jsonResult = converter.toJson(localTime);

    // Ensure the result is a String and ends with 'Z' (Z means UTC / Zero offset)
    expect(jsonResult, isA<String>());
    expect((jsonResult as String).endsWith('Z'), isTrue);
  });
}
