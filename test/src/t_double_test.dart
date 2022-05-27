import 'package:flutter_test/flutter_test.dart';
import 'package:tdata/src/t_double.dart';

void main() {
  group('fromDouble', () {
    test('should correct double', () {
      final instance = TDouble.fromDouble(5.0);
      expect(instance.realValue, 5.0);
      expect(instance.isSuccess, true);
    });

    test(
        'should return correct double and isSuccess true when value double == tDataDoubleDefaultValue ',
        () {
      final instance = TDouble.fromDouble(tDataDoubleDefaultValue);
      expect(instance.realValue, tDataDoubleDefaultValue);
      expect(instance.isSuccess, true);
    });
  });

  group('fromString', () {
    test('should correct double when correct String', () {
      final instance = TDouble.fromString("5.0");
      expect(instance.realValue, 5.0);
      expect(instance.isSuccess, true);
    });

    test(
        'should return correct double and isSuccess true when value String == tDataDoubleDefaultValue ',
        () {
      final instance = TDouble.fromString(tDataDoubleDefaultValue.toString());
      expect(instance.realValue, tDataDoubleDefaultValue);
      expect(instance.isSuccess, true);
    });

    test('should correct double when given String with space', () {
      final instance = TDouble.fromString("5.0 ");
      expect(instance.realValue, 5.0);
      expect(instance.isSuccess, true);
    });

    test(
        'should correct double when correct String when valueIfError param provided',
        () {
      final instance = TDouble.fromString("5.0", valueIfError: 0.0);
      expect(instance.realValue, 5.0);
      expect(instance.isSuccess, true);
    });

    test(
        'should return correct double and isSuccess true when value String == tDataDoubleDefaultValue and valueIfError param provided',
        () {
      final instance = TDouble.fromString(tDataDoubleDefaultValue.toString(),
          valueIfError: 0.0);
      expect(instance.realValue, tDataDoubleDefaultValue);
      expect(instance.isSuccess, true);
    });

    test(
        'should correct double when given String with space and valueIfError param provided',
        () {
      final instance = TDouble.fromString("5.0 ", valueIfError: 0.0);
      expect(instance.realValue, 5.0);
      expect(instance.isSuccess, true);
    });

    test(
        'should return tDataDoubleDefaultValue and isSuccess false when given wrong String int ',
        () {
      final instance = TDouble.fromString("aa");
      expect(instance.realValue, tDataDoubleDefaultValue);
      expect(instance.isSuccess, false);
    });

    test(
        'should return valueIfError and isSuccess false when given wrong String double and valueIfError param provided ',
        () {
      double defValue = 4.0;
      final instance = TDouble.fromString("uu", valueIfError: defValue);
      expect(instance.realValue, defValue);
      expect(instance.isSuccess, false);
    });
  });
}
