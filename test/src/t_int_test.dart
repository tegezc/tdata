import 'package:flutter_test/flutter_test.dart';
import 'package:tdata/src/t_int.dart';

void main() {
  group('fromInt', () {
    test('should correct int', () {
      TInt instance = TInt.fromInt(5);
      expect(instance.realValue, 5);
      expect(instance.isSuccess, true);
    });

    test(
        'should return correct int and isSuccess true when value int == tDataIntDefaultValue ',
        () {
      final instance = TInt.fromInt(tDataIntDefaultValue);
      expect(instance.realValue, tDataIntDefaultValue);
      expect(instance.isSuccess, true);
    });
  });

  group('fromString', () {
    test('should correct int when correct String', () {
      final instance = TInt.fromString("5");
      expect(instance.realValue, 5);
      expect(instance.isSuccess, true);
    });

    test(
        'should return correct int and isSuccess true when value String == tDataIntDefaultValue ',
        () {
      final instance = TInt.fromString(tDataIntDefaultValue.toString());
      expect(instance.realValue, tDataIntDefaultValue);
      expect(instance.isSuccess, true);
    });

    test('should correct int when given String with space', () {
      final instance = TInt.fromString("5 ");
      expect(instance.realValue, 5);
      expect(instance.isSuccess, true);
    });

    test(
        'should correct int when correct String when valueIfError param provided',
        () {
      final instance = TInt.fromString("5", valueIfError: 0);
      expect(instance.realValue, 5);
      expect(instance.isSuccess, true);
    });

    test(
        'should return correct int and isSuccess true when value String == tDataIntDefaultValue and valueIfError param provided',
        () {
      final instance =
          TInt.fromString(tDataIntDefaultValue.toString(), valueIfError: 0);
      expect(instance.realValue, tDataIntDefaultValue);
      expect(instance.isSuccess, true);
    });

    test(
        'should correct int when given String with space and valueIfError param provided',
        () {
      final instance = TInt.fromString("5 ", valueIfError: 0);
      expect(instance.realValue, 5);
      expect(instance.isSuccess, true);
    });

    test(
        'should return tDataIntDefaultValue and isSuccess false when given wrong String int ',
        () {
      final instance = TInt.fromString("0.0");
      expect(instance.realValue, tDataIntDefaultValue);
      expect(instance.isSuccess, false);
    });

    test(
        'should return valueIfError and isSuccess false when given wrong String int and valueIfError param provided ',
        () {
      int defValue = -1;
      final instance = TInt.fromString("0.0", valueIfError: defValue);
      expect(instance.realValue, defValue);
      expect(instance.isSuccess, false);
    });
  });
}
