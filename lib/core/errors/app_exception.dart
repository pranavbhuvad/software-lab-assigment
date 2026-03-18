class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const AppException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

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
