class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const AppException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  // ── Factories ──────────────────────────────────────────────────
  factory AppException.network() => const AppException(
        message: 'No internet connection. Please try again.',
        errorCode: 'NETWORK_ERROR',
      );

  factory AppException.server(int statusCode, String message) => AppException(
        message: message,
        statusCode: statusCode,
        errorCode: 'SERVER_ERROR',
      );

  factory AppException.unauthorized() => const AppException(
        message: 'Session expired. Please login again.',
        statusCode: 401,
        errorCode: 'UNAUTHORIZED',
      );

  factory AppException.unknown() => const AppException(
        message: 'Something went wrong. Please try again.',
        errorCode: 'UNKNOWN_ERROR',
      );

  @override
  String toString() => 'AppException($errorCode): $message';
}

// ── Subclasses ─────────────────────────────────────────────────

class BadRequestException extends AppException {
  const BadRequestException([String message = 'All fields are required.'])
      : super(message: message, errorCode: 'BAD_REQUEST');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(
      [String message = 'Access denied! Unauthorized user.'])
      : super(message: message, statusCode: 401, errorCode: 'UNAUTHORIZED');
}

class ServerException extends AppException {
  const ServerException([String message = 'Server error. Please try again.'])
      : super(message: message, errorCode: 'SERVER_ERROR');
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection.'])
      : super(message: message, errorCode: 'NETWORK_ERROR');
}

class EmailExistsException extends AppException {
  const EmailExistsException([String message = 'Email already exists.'])
      : super(message: message, errorCode: 'EMAIL_EXISTS');
}

class RegistrationFailedException extends AppException {
  const RegistrationFailedException([String message = 'Registration failed.'])
      : super(message: message, errorCode: 'REGISTRATION_FAILED');
}

class InvalidTokenException extends AppException {
  const InvalidTokenException([String message = 'Invalid token.'])
      : super(message: message, errorCode: 'INVALID_TOKEN');
}

// ── Parser ─────────────────────────────────────────────────────

AppException parseApiException(int statusCode, String? message) {
  final msg = message ?? '';
  if (statusCode == 401) return UnauthorizedException(msg);
  if (msg.toLowerCase().contains('email already')) {
    return EmailExistsException(msg);
  }
  if (msg.toLowerCase().contains('invalid token')) {
    return InvalidTokenException(msg);
  }
  if (msg.toLowerCase().contains('registration failed')) {
    return RegistrationFailedException(msg);
  }
  if (msg.toLowerCase().contains('social id')) {
    return BadRequestException(msg);
  }
  if (statusCode >= 500) return ServerException(msg);
  return BadRequestException(
      msg.isNotEmpty ? msg : 'All fields are required.');
}