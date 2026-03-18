import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../errors/error_handler.dart';
import '../storage/local_storage.dart';

const String _baseUrl = 'https://api.yourfarmapp.com/v1';
const Duration _timeout = Duration(seconds: 15);

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

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client
          .post(
            _uri(path),
            headers: _headers,
            body: jsonEncode(body ?? {}),
          )
          .timeout(_timeout);
      return _parse(response);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client
          .put(
            _uri(path),
            headers: _headers,
            body: jsonEncode(body ?? {}),
          )
          .timeout(_timeout);
      return _parse(response);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

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

  Map<String, dynamic> _parse(http.Response response) {
    if (kDebugMode) {
      debugPrint('[HTTP] ${response.request?.method} '
          '${response.request?.url} → ${response.statusCode}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw ErrorHandler.handleResponse(response);
  }

  void dispose() => _client.close();
}