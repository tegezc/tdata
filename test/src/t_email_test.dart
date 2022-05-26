import 'package:flutter_test/flutter_test.dart';
import 'package:tdata/src/t_email.dart';

void main() {
  final List<String> validEmail = [
    'email@example.com',
    'firstname.lastname@example.com',
    'email@subdomain.example.com',
    'firstname+lastname@example.com',
    '1234567890@example.com',
    '_______@example.com',
    'email@example.name',
    'email@example.museum',
    'email@example.co.jp',
    'firstname-lastname@example.com',
    //'email@123.123.123.123',
    'email@[123.123.123.123]',
    '"email"@example.com',
    'email@example-one.com',
  ];

  final List<String> invalidEmail = [
    'plainaddress',
    '#@%^%#\$@#\$@#.com',
    '@example.com',
    'Joe Smith <email@example.com>',
    'email.example.com',
    'email@example@example.com',
    '    .email@example.com',
    'email@example',
    // 'email@-example.com',
    'email@111.222.333.44444',
    'email@example..com',
    'Abc..123@example.com',
    'email.@example.com',
    'email..email@example.com',
    'email@example.com (Joe Smith)',
    // 'email@example.web',
  ];

  test('validate validEmail is valid email address', () {
    for (String email in validEmail) {
      final instance = TEmail.fromString(email);
      expect(instance.stringEmail, email);
      expect(instance.isValid, true);
    }
  });

  test('validate invalidEmail is invalid email address', () {
    for (String email in invalidEmail) {
      final instance = TEmail.fromString(email);
      expect(instance.stringEmail, email);
      expect(instance.isValid, false);
    }
  });
}
