/// Robust, tested input validators for client-side feedback.
abstract final class Validators {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Validates email address format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password field presence and minimum length
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validates confirmation password against the original
  static String? confirmPassword(String? confirm, String? original) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirm != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates generic non-empty required field
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates OTP code of specified length
  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'Verification code is required';
    }
    if (value.trim().length != length) {
      return 'Enter the full $length-digit code';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Code must contain only digits';
    }
    return null;
  }

  /// Checks individual password rules for UI criteria checklist
  static bool hasMinLength(String? value, [int length = 8]) =>
      value != null && value.length >= length;

  static bool hasUppercase(String? value) =>
      value != null && RegExp(r'[A-Z]').hasMatch(value);

  static bool hasNumber(String? value) =>
      value != null && RegExp(r'[0-9]').hasMatch(value);

  static bool hasSpecialChar(String? value) =>
      value != null && RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);
}
