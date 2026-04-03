import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  const converter = TIntegerConverter();

  group('TIntegerConverter', () {
    test('fromJson: harus menghasilkan TInteger yang valid', () {
      final result = converter.fromJson("100.5");
      expect(result, isA<TInteger>());
      expect(result.value, 100);
    });

    test('toJson: harus mengembalikan int murni', () {
      final tint = TInteger(50);
      final json = converter.toJson(tint);

      expect(json, isA<int>());
      expect(json, 50);
    });
  });
}