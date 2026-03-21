import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:software_lab/core/errors/app_exception.dart';
import '../errors/error_handler.dart';
import '../storage/local_storage.dart';

const String _baseUrl = 'https://sowlab.com/assignment';
const Duration _timeout = Duration(seconds: 30);

final networkClientProvider = Provider<NetworkClient>((ref) {
  final storage = ref.read(localStorageProvider);
  return NetworkClient(storage);
});

class NetworkClient {
  final LocalStorage _storage;
  final http.Client _client;

  NetworkClient(this._storage) : _client = http.Client();

  Map<String, String> get _headers {
    final token = _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path, [Map<String, dynamic>? params]) {
    final uri = Uri.parse('$_baseUrl$path');
    if (params == null) return uri;
    return uri.replace(
      queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  // ── GET ────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _client
          .get(_uri(path, params), headers: _headers)
          .timeout(_timeout);
      return _parse(response);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ── POST (JSON) ────────────────────────────────────────────────
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final token = _storage.getToken();
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      if (kDebugMode) {
        debugPrint('[POST] $path');
        debugPrint('[BODY] ${jsonEncode(body ?? {})}');
      }

      final response = await _client
          .post(_uri(path), headers: headers, body: jsonEncode(body ?? {}))
          .timeout(_timeout);

      return _parse(response);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // Separate auth header getter to avoid Content-Type conflict
  Map<String, String> get _authHeader {
    final token = _storage.getToken();
    return {if (token != null) 'Authorization': 'Bearer $token'};
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'registration_proof',
  }) async {
    final uri = _uri(path);
    final request = http.MultipartRequest('POST', uri);

    final token = _storage.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields.addAll(fields);

    if (file != null) {
      // ── Sanitize filename — remove commas, spaces, special chars ──
      final ext = file.path.split('.').last.toLowerCase();
      final cleanName = 'registration_proof.$ext';

      request.files.add(
        await http.MultipartFile.fromPath(
          fileField,
          file.path, // ← use original file path
          filename: cleanName, // ← but send clean name to server
        ),
      );
    }

    try {
      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed);
      return _parseMultipart(response);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ── Special parser for multipart responses ─────────────────
  // Strips any garbage text before the JSON body
  Map<String, dynamic> _parseMultipart(http.Response response) {
    if (kDebugMode) {
      debugPrint('┌─── RAW REGISTER RESPONSE ──────────────────────────');
      debugPrint('│ Status : ${response.statusCode}');
      debugPrint('│ Body   : ${response.body}');
      debugPrint('└────────────────────────────────────────────────────');
    }

    // ── Strip any text before the first '{' ──────────────────
    final body = response.body;
    final jsonStart = body.indexOf('{');
    final cleanBody = jsonStart > 0 ? body.substring(jsonStart) : body;

    late Map<String, dynamic> json;
    try {
      json = jsonDecode(cleanBody) as Map<String, dynamic>;
    } catch (_) {
      throw const AppException(
        message: 'Invalid response format from server.',
        errorCode: 'PARSE_ERROR',
      );
    }

    final success = json['success'];
    if (success == false) {
      final message = json['message']?.toString() ?? 'Request failed.';
      throw AppException(
        message: message,
        statusCode: response.statusCode,
        errorCode: 'API_ERROR',
      );
    }

    return json;
  }

  // ── PUT ────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client
          .put(_uri(path), headers: _headers, body: jsonEncode(body ?? {}))
          .timeout(_timeout);
      return _parse(response);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────
  Future<void> delete(String path) async {
    try {
      final response = await _client
          .delete(_uri(path), headers: _headers)
          .timeout(_timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ErrorHandler.handleResponse(response);
      }
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ── Parser ─────────────────────────────────────────────────────
  Map<String, dynamic> _parse(http.Response response) {
    if (kDebugMode) {
      debugPrint(
        '[HTTP] ${response.request?.method} '
        '${response.request?.url} → ${response.statusCode}',
      );
      debugPrint('[BODY] ${response.body}');
    }

    // ── Non-2xx status ──────────────────────────────────────
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ErrorHandler.handleResponse(response);
    }

    // ── Empty body ──────────────────────────────────────────
    if (response.body.isEmpty) return {};

    // ── Strip garbage prefix before { ──────────────────────
    final body = response.body;
    final jsonStart = body.indexOf('{');
    final cleanBody = jsonStart > 0 ? body.substring(jsonStart) : body;

    // ── Safe JSON decode ────────────────────────────────────
    late Map<String, dynamic> json;
    try {
      json = jsonDecode(cleanBody) as Map<String, dynamic>;
    } catch (_) {
      throw const AppException(
        message: 'Invalid response format from server.',
        errorCode: 'PARSE_ERROR',
      );
    }

    // ── Check success: false for ALL endpoints ──────────────
    final success = json['success'];
    if (success == false) {
      final message = json['message']?.toString() ?? 'Request failed.';
      throw AppException(
        message: message,
        statusCode: response.statusCode,
        errorCode: 'API_ERROR',
      );
    }

    return json;
  }

  void dispose() => _client.close();
}
