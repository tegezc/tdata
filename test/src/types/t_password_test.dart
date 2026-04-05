import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TPassword - Constructors & Basics', () {
    test('Must throw error if empty or less than 6 characters', () {
      expect(() => TPassword(""), throwsFormatException);
      expect(() => TPassword("12345"), throwsFormatException);
    });

    test('Does NOT trim spaces because space is a valid character', () {
      // User might use "pass word 123" as a passphrase
      final pwd = TPassword(" password ");
      expect(pwd.value.length, 10);
    });
  });

  group('TPassword - Strength Evaluation', () {
    test('Detects Weak password', () {
      final pwd = TPassword("abcdef"); // Only lowercase, 6 char
      expect(pwd.strength, PasswordStrength.weak);
      expect(pwd.isStrongEnoughForRegistration, isFalse);
    });

    test('Detects Medium password', () {
      final pwd = TPassword(
          "Abcdef12"); // Uppercase, lowercase, number, 8 char (Score 4)
      expect(pwd.strength, PasswordStrength.medium);
      expect(pwd.isStrongEnoughForRegistration, isFalse);
    });

    test('Detects Strong password', () {
      final pwd = TPassword("Suparman@2025"); // Complete with symbol (Score 5)
      expect(pwd.strength, PasswordStrength.strong);
      expect(pwd.isStrongEnoughForRegistration, isTrue);
    });
  });

  group('TPassword - Security', () {
    test('toObscured returns asterisks matching original length', () {
      final pwd = TPassword("rahasia");
      expect(pwd.toObscured(), "*******");
      expect(pwd.toObscured().length, 7);

      // Proves that original value remains safe and unchanged
      expect(pwd.value, "rahasia");
    });
  });
}
