abstract final class AppValidators {

  // ── Required ───────────────────────────────────────────────────
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  // ── Email ──────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address.';
    return null;
  }

  // ── Phone ──────────────────────────────────────────────────────
  // Must be 10 digits and start with 6–9
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }
    final trimmed = value.trim();
    if (trimmed.length != 10) {
      return 'Phone number must be exactly 10 digits.';
    }
    final regex = RegExp(r'^[6-9][0-9]{9}$');
    if (!regex.hasMatch(trimmed)) {
      return 'Number must start with 6, 7, 8, or 9.';
    }
    return null;
  }

  // ── Password ───────────────────────────────────────────────────
  // Min 8 chars, at least one uppercase, at least one number
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  // ── Confirm Password ───────────────────────────────────────────
  static String? Function(String?) confirmPassword(String original) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Please confirm your password.';
      if (value != original) return 'Passwords do not match.';
      return null;
    };
  }

  // ── Zip Code ───────────────────────────────────────────────────
  static String? zipCode(String? value) {
    if (value == null || value.trim().isEmpty) return 'Zip code is required.';
    if (value.trim().length < 4) return 'Enter a valid zip code.';
    return null;
  }

  // ── Min Length ─────────────────────────────────────────────────
  static String? minLength(String? value, int min) {
    if (value == null || value.length < min) {
      return 'Must be at least $min characters.';
    }
    return null;
  }
}