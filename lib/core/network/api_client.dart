import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:library_app/core/constants/api_constants.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/utils/secure_storage.dart';

/// Centralized HTTP client with automatic token injection, error handling,
/// and consistent response parsing.
class ApiClient {
  static ApiClient? _instance;
  final http.Client _client;
  final SecureStorage _storage;

  ApiClient._()
      : _client = http.Client(),
        _storage = SecureStorage.instance;

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  /// Dispose the HTTP client.
  void dispose() {
    _client.close();
    _instance = null;
  }

  /// Common headers with optional auth token.
  Future<Map<String, String>> _headers({
    bool requireAuth = true,
    bool isMultipart = false,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    if (requireAuth) {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Build full URL from endpoint path.
  Uri _buildUri(String endpoint, {Map<String, String>? queryParams}) {
    final url = '${ApiConstants.baseUrl}$endpoint';
    final uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  /// Process response and throw appropriate exceptions.
  dynamic _processResponse(http.Response response) {
    final dynamic body;
    try {
      body = jsonDecode(response.body);
    } on FormatException {
      throw const AppException('Format response dari server tidak valid');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;

      case 401:
        // Check if it's an unauthenticated error (token expired)
        final message = body is Map ? body['message'] : null;
        if (message == 'Unauthenticated.') {
          throw const UnauthorizedException();
        }
        throw WrongPasswordException(
          body is Map ? (body['message'] ?? 'Unauthorized') : 'Unauthorized',
        );

      case 403:
        throw ForbiddenException(
          body is Map ? (body['message'] ?? 'Forbidden') : 'Forbidden',
        );

      case 404:
        throw NotFoundException(
          body is Map ? (body['message'] ?? 'Not found') : 'Not found',
        );

      case 422:
        final errors = <String, List<String>>{};
        if (body is Map && body['data'] != null && body['data'] is Map) {
          (body['data'] as Map).forEach((key, value) {
            if (value is List) {
              errors[key.toString()] = value.map((e) => e.toString()).toList();
            }
          });
        }
        throw ValidationException(
          message: body is Map ? (body['message'] ?? 'Validation error') : 'Validation error',
          errors: errors,
        );

      case 429:
        throw const RateLimitException();

      case >= 500:
        throw ServerException(
          body is Map ? (body['message'] ?? 'Server error') : 'Server error',
        );

      default:
        throw AppException(
          body is Map ? (body['message'] ?? 'Terjadi kesalahan') : 'Terjadi kesalahan',
          statusCode: response.statusCode,
        );
    }
  }

  /// GET request.
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requireAuth = true,
  }) async {
    try {
      final response = await _client
          .get(
            _buildUri(endpoint, queryParams: queryParams),
            headers: await _headers(requireAuth: requireAuth),
          )
          .timeout(ApiConstants.connectionTimeout);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is http.ClientException) {
        throw const NetworkException();
      }
      throw AppException('Unexpected error: $e');
    }
  }

  /// POST request with JSON body.
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    try {
      final response = await _client
          .post(
            _buildUri(endpoint),
            headers: await _headers(requireAuth: requireAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is http.ClientException) {
        throw const NetworkException();
      }
      throw AppException('Unexpected error: $e');
    }
  }

  /// PUT request with JSON body.
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    try {
      final response = await _client
          .put(
            _buildUri(endpoint),
            headers: await _headers(requireAuth: requireAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is http.ClientException) {
        throw const NetworkException();
      }
      throw AppException('Unexpected error: $e');
    }
  }

  /// DELETE request.
  Future<dynamic> delete(
    String endpoint, {
    bool requireAuth = true,
  }) async {
    try {
      final response = await _client
          .delete(
            _buildUri(endpoint),
            headers: await _headers(requireAuth: requireAuth),
          )
          .timeout(ApiConstants.connectionTimeout);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is http.ClientException) {
        throw const NetworkException();
      }
      throw AppException('Unexpected error: $e');
    }
  }

  /// Multipart POST request (for file uploads).
  Future<dynamic> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
    bool requireAuth = true,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        _buildUri(endpoint),
      );

      request.headers.addAll(await _headers(requireAuth: requireAuth, isMultipart: true));

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (files != null) {
        for (final entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      final streamedResponse = await request.send().timeout(ApiConstants.connectionTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is http.ClientException) {
        throw const NetworkException();
      }
      throw AppException('Unexpected error: $e');
    }
  }

  /// Multipart POST with _method=PUT (for updating with file uploads).
  Future<dynamic> putMultipart(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
    bool requireAuth = true,
  }) async {
    final allFields = <String, String>{
      '_method': 'PUT',
      ...?fields,
    };
    return postMultipart(
      endpoint,
      fields: allFields,
      files: files,
      requireAuth: requireAuth,
    );
  }
}
