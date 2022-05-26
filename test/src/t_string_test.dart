import 'package:flutter_test/flutter_test.dart';
import 'package:tdata/src/t_string.dart';

void main() {
  group('fromInt', () {
    test('should correct string', () {
      TString instance = TString.string('AAAAAAA');
      expect(instance.realValue, 'AAAAAAA');
    });
  });
}
