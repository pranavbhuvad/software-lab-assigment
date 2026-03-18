import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'app_exception.dart';

abstract final class ErrorHandler {
  static AppException handle(Object error) {
    if (error is AppException) return error;

    if (error is SocketException) return AppException.network();

    if (error is http.ClientException) return AppException.network();

    if (error is FormatException) {
      return const AppException(
        message: 'Invalid response format from server.',
        errorCode: 'PARSE_ERROR',
      );
    }

    return AppException.unknown();
  }

  static AppException handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      throw StateError('handleResponse called on a success response.');
    }

    if (response.statusCode == 401) return AppException.unauthorized();

    final message = _extractMessage(response.body);
    return AppException.server(response.statusCode, message);
  }

  static String _extractMessage(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'An error occurred.';
      }
    } catch (_) {}
    return 'An error occurred.';
  }
}