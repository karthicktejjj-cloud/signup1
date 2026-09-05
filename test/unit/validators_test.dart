import 'package:flutter_test/flutter_test.dart';
import 'package:signup/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('email validator returns null on valid emails', () {
      expect(Validators.email('client@company.com'), isNull);
      expect(Validators.email('lead.engineer@enterprise.io'), isNull);
    });

    test('email validator returns error on empty or invalid formats', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('@missingdomain.com'), isNotNull);
    });

    test('password validator enforces minimum length', () {
      expect(Validators.password('12345678', minLength: 8), isNull);
      expect(Validators.password('short', minLength: 8), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('confirmPassword matches identical passwords only', () {
      expect(Validators.confirmPassword('Secret123!', 'Secret123!'), isNull);
      expect(Validators.confirmPassword('Secret123!', 'Mismatch!'), isNotNull);
      expect(Validators.confirmPassword('', 'Secret123!'), isNotNull);
    });

    test('otp validator validates length and numeric digits', () {
      expect(Validators.otp('123456', length: 6), isNull);
      expect(Validators.otp('12345', length: 6), isNotNull);
      expect(Validators.otp('12345A', length: 6), isNotNull);
      expect(Validators.otp('', length: 6), isNotNull);
    });

    test('password criteria helpers correctly detect rules', () {
      expect(Validators.hasMinLength('12345678', 8), isTrue);
      expect(Validators.hasMinLength('123', 8), isFalse);
      expect(Validators.hasUppercase('passwordA'), isTrue);
      expect(Validators.hasUppercase('password'), isFalse);
      expect(Validators.hasNumber('pass1'), isTrue);
      expect(Validators.hasNumber('pass'), isFalse);
    });
  });
}
