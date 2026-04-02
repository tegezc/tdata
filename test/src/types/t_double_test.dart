import 'package:test/test.dart';
import 'package:tdata/tdata.dart';

void main() {
  group('TDouble - Parsing & Constructors', () {
    test('fromJson should successfully parse valid numbers', () {
      expect(TDouble.fromJson(150.5).value, 150.5);
      expect(TDouble.fromJson("150.5").value, 150.5);
    });

    test('fromJson should throw FormatException if format is wrong', () {
      expect(() => TDouble.fromJson("Bukan Angka"), throwsFormatException);
      expect(() => TDouble.fromJson(null), throwsFormatException);
    });

    test('fromInput should return fallback if input is messed up', () {
      expect(TDouble.fromInput("Kacau").value, 0.0);
      expect(TDouble.fromInput("Kacau", fallback: 10.0).value, 10.0);
    });

    test('fromInput should be able to handle decimal comma', () {
      expect(TDouble.fromInput("1,23").value, 1.23); // Comma becomes dot
    });
  });

  group('TDouble - Arithmetic & Guards', () {
    test('Addition runs normally', () {
      final a = TDouble.safe(10.5);
      final b = TDouble.safe(2.0);
      expect((a + b).value, 12.5);
    });

    test(
        'Division by zero should trigger _debugFail (StateError) in Debug mode',
        () {
      final a = TDouble.safe(10.0);
      final b = TDouble.safe(0.0);

      // Because we are running tests in Debug environment, assert will be active
      // and throw StateError from _debugFail that we made.
      expect(() => a / b, throwsA(isA<AssertionError>()));
    });
  });

  group('TDouble - Formatting', () {
    test('toDisplay produces the correct string format', () {
      final a = TDouble.safe(1500.5);
      expect(a.toDisplay(decimals: 2), "1500.50");
      expect(a.toDisplay(decimals: 0), "1501"); // Automatically rounded by Dart
    });
  });
}
