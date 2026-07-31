import 'package:flutter_test/flutter_test.dart';
import 'package:alumniconnect_plus/core/utils/validators.dart';

void main() {
  group('AppValidators Unit Tests', () {
    test('validateEmail returns error on empty string', () {
      expect(AppValidators.validateEmail(''), equals('Email address is required'));
    });

    test('validateEmail returns error on invalid email format', () {
      expect(AppValidators.validateEmail('invalid-email'), equals('Enter a valid email address (e.g. name@bitcollege.edu)'));
    });

    test('validateEmail returns null on valid email', () {
      expect(AppValidators.validateEmail('student@bitcollege.edu'), isNull);
    });

    test('validatePassword enforces length and complexity', () {
      expect(AppValidators.validatePassword('short'), equals('Password must be at least 8 characters long'));
      expect(AppValidators.validatePassword('lowercase123'), equals('Password must contain at least one uppercase letter'));
      expect(AppValidators.validatePassword('NoDigitsHere'), equals('Password must contain at least one digit'));
      expect(AppValidators.validatePassword('ValidPass123'), isNull);
    });
  });
}
