import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TPhoneNumber - Normalization & E.164', () {
    test('Must normalize various input styles to E.164 format', () {
      final target = "+6281234567890";

      // Case 1: Standard ID format (0812...)
      expect(TPhoneNumber("081234567890").value, target);

      // Case 2: Already uses 62 but without plus
      expect(TPhoneNumber("6281234567890").value, target);

      // Case 3: Dirty input with spaces and dashes (Often from copy-paste)
      expect(TPhoneNumber("+62 812-3456-7890").value, target);

      // Case 4: Dirty input with parentheses
      expect(TPhoneNumber("(0812) 3456 7890").value, target);
    });

    test('Can normalize using ISO Code of other countries (Example: SG/US)',
        () {
      // Singapore (SG) automatically uses dial code 65
      final sgPhone = TPhoneNumber("091234567", defaultIsoCode: 'SG');
      expect(sgPhone.value, "+6591234567");
      expect(sgPhone.countryCode, "65");

      // US automatically uses dial code 1
      final usPhone = TPhoneNumber("2025550123", defaultIsoCode: 'US');
      expect(usPhone.value, "+12025550123");
      expect(usPhone.countryCode, "1");
    });
  });

  group('TPhoneNumber - Validation', () {
    test('Throws error if number is too short or invalid', () {
      expect(() => TPhoneNumber("081"),
          throwsFormatException); // Too short (< 10 digit E.164)
      expect(() => TPhoneNumber("bukan_nomor"), throwsFormatException);
    });

    test('tryParse must return null (not error) for invalid input', () {
      expect(TPhoneNumber.tryParse("081"), isNull);
      expect(TPhoneNumber.tryParse("bukan_nomor"), isNull);
      expect(TPhoneNumber.tryParse(null), isNull);
      expect(TPhoneNumber.tryParse(""), isNull);

      // Ensure valid input still parses successfully
      expect(TPhoneNumber.tryParse("081234567890")?.value, "+6281234567890");
    });
  });

  group('TPhoneNumber - Display & Masking', () {
    test('toDisplay formats beautifully', () {
      final phone = TPhoneNumber("081234567890");
      expect(phone.toDisplay(), "+62 812-3456-7890");
    });

    test('toMasked censors the middle part of the number', () {
      final phone = TPhoneNumber("+6281234567890");
      expect(phone.toMasked(), "+62 812-****-7890");
    });

    test(
        'toDisplay and toMasked are safe for short numbers (Example: Singapore)',
        () {
      final sgPhone = TPhoneNumber("91234567", defaultIsoCode: 'SG');

      // Because < 10 digits, it must enter the fallback block without error
      expect(sgPhone.toDisplay(), "+65 91234567");
      expect(sgPhone.toMasked(), "+65 ****");
    });
  });

  group('TPhoneNumberConverter - Serialization', () {
    const converter = TPhoneNumberConverter();

    test('fromJson must return valid TPhoneNumber', () {
      final phone = converter.fromJson("+6281234567890");
      expect(phone.value, "+6281234567890");
    });

    test('toJson must produce pure string without spaces', () {
      final phone = TPhoneNumber("+62 812-3456-7890"); // Dirty input
      final json = converter.toJson(phone);

      expect(json, "+6281234567890"); // Output must be clean
    });
  });
}
