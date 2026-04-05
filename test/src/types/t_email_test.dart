import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TEmail - Sanitization & Validation', () {
    test('Must automatically convert to lowercase and remove spaces', () {
      final email1 = TEmail("  User@GMAIL.com  ");
      expect(email1.value, "user@gmail.com");

      final email2 = TEmail("ADMIN@company.CO.ID");
      expect(email2.value, "admin@company.co.id");

      final email3 = TEmail("ADMIN@x.CO.ID");
      expect(email3.value, "admin@x.co.id");
    });

    test('Must throw FormatException if email is invalid', () {
      expect(() => TEmail("bukan_email"), throwsFormatException);
      expect(() => TEmail("user@gmail"), throwsFormatException); // Without .com
      expect(() => TEmail("@domain.com"),
          throwsFormatException); // Without username
    });

    test('tryParse returns null for invalid input', () {
      expect(TEmail.tryParse("invalid_email"), isNull);
      expect(TEmail.tryParse(""), isNull);
      expect(TEmail.tryParse(null), isNull);
    });
  });

  group('TEmail - Utilities & Security', () {
    test('username and domain extracted correctly', () {
      final email = TEmail("developer@tdata.io");
      expect(email.username, "developer");
      expect(email.domain, "tdata.io");
      expect(email.isGmail, isFalse);
    });

    test('toMasked must censor email correctly', () {
      final emailNormal = TEmail("suparman@gmail.com");
      expect(emailNormal.toMasked(), "sup***@gmail.com");

      final emailPendek = TEmail("al@yahoo.com");
      expect(emailPendek.toMasked(),
          "a***@yahoo.com"); // Prevents index out of bounds
    });
  });
}
