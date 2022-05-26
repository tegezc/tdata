import 'package:flutter_test/flutter_test.dart';
import 'package:tdata/src/t_boolean.dart';

void main() {
  group('fromBool', () {
    test('should correct bool true', () {
      final instance = TBool.fromBool(true);
      expect(instance.realValue, true);
      expect(instance.isSuccess, true);
    });

    test('should return correct bool false', () {
      final instance = TBool.fromBool(false);
      expect(instance.realValue, false);
      expect(instance.isSuccess, true);
    });
  });

  group('fromInt', () {
    test('should true for int 1', () {
      final instance = TBool.fromInt(1);
      expect(instance.realValue, true);
      expect(instance.isSuccess, true);
    });

    test('should return false for  int 0', () {
      final instance = TBool.fromInt(0);
      expect(instance.realValue, false);
      expect(instance.isSuccess, true);
    });
    test('should return false for  int not 1 or 0', () {
      final instance = TBool.fromInt(-1);
      expect(instance.realValue, false);
      expect(instance.isSuccess, false);
    });
  });

  group('fromString', () {
    test('should return true for string 1', () {
      final instance = TBool.fromString("1");
      expect(instance.realValue, true);
      expect(instance.isSuccess, true);
    });

    test('should return false for string 0', () {
      final instance = TBool.fromString('0');
      expect(instance.realValue, false);
      expect(instance.isSuccess, true);
    });

    test('should true when string 1 has space char', () {
      final instance = TBool.fromString("1 ");
      expect(instance.realValue, true);
      expect(instance.isSuccess, true);
    });

    test('should false when string 0 has space char', () {
      final instance = TBool.fromString("0 ");
      expect(instance.realValue, false);
      expect(instance.isSuccess, true);
    });

    test(
        'should return false and isSuccess false when string not valid boolean',
        () {
      final instance = TBool.fromString(
        "5",
      );
      expect(instance.realValue, false);
      expect(instance.isSuccess, false);
    });
  });
}
