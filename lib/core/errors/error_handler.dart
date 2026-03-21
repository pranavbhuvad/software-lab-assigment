import 'dart:convert';
import 'dart:developer';
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
    // ── Log raw response for debugging ──────────────────────
    log('[ERROR RESPONSE] status: ${response.statusCode}');
    log('[ERROR RESPONSE] body: ${response.body}'); // ← shows real API message

    String message = 'Something went wrong.';
    try {
      if (response.body.isNotEmpty) {
        final json = jsonDecode(response.body);
        if (json is Map<String, dynamic>) {
          message =
              json['message']?.toString() ??
              json['error']?.toString() ??
              message;
        }
      }
    } catch (_) {
      message = 'Server returned status ${response.statusCode}';
    }

    if (response.statusCode >= 500) {
      return AppException.server(response.statusCode, message);
    }

    return AppException(
      message: message,
      statusCode: response.statusCode,
      errorCode: response.statusCode == 401 ? 'UNAUTHORIZED' : 'REQUEST_ERROR',
    );
  }
}
