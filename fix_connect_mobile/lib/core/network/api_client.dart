import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/network/token_storage.dart';
import 'package:flutter/foundation.dart';

/// Centralised HTTP client.
///
/// All feature data-sources should depend on this class, never on [Dio] directly.
/// It handles:
///   - Base URL, timeouts, and JSON content-type headers
///   - Automatic Bearer token injection via [_AuthInterceptor]
///   - Unified [DioException] → domain exception mapping
///   - Request / response logging in debug builds
class ApiClient {
  ApiClient({required TokenStorage tokenStorage, required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_AuthInterceptor(tokenStorage));

    if (kDebugMode) {
      _dio.interceptors.add(_PrettyDioLogger());
    }
  }

  late final Dio _dio;

  // ── HTTP verbs ──────────────────────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _call(() => _dio.get<T>(path, queryParameters: queryParameters));

  Future<Response<T>> post<T>(String path, {Object? data}) =>
      _call(() => _dio.post<T>(path, data: data));

  Future<Response<T>> put<T>(String path, {Object? data}) =>
      _call(() => _dio.put<T>(path, data: data));

  Future<Response<T>> patch<T>(String path, {Object? data}) =>
      _call(() => _dio.patch<T>(path, data: data));

  Future<Response<T>> delete<T>(String path) =>
      _call(() => _dio.delete<T>(path));

  // ── Internal ────────────────────────────────────────────────────────────────

  Future<Response<T>> _call<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  Exception _mapException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        // Surface the real OS-level message so dev can tell the difference
        // between "cleartext blocked", "connection refused", "host unreachable" etc.
        return NetworkException(e.message ?? 'Connection failed');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return const UnauthorizedException();
        final message =
            (e.response?.data as Map<String, dynamic>?)?['message']
                as String? ??
            'Server error';
        return ServerException(message: message, statusCode: code);
      default:
        return ServerException(message: e.message ?? 'Unknown error');
    }
  }
}

/// Reads the stored access token and injects it as a Bearer header.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

// ── Pretty console logger (debug only) ──────────────────────────────────────

class _PrettyDioLogger extends Interceptor {
  static final _h = '─' * 62;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['_sw'] = Stopwatch()..start();

    final buf = StringBuffer()
      ..writeln('┌$_h')
      ..writeln('│ ▶  ${options.method.padRight(6)} ${options.uri}');

    for (final e in options.headers.entries) {
      final val = e.key == 'Authorization'
          ? 'Bearer [••••]'
          : e.value.toString();
      buf.writeln('│    ${e.key}: $val');
    }

    if (options.data != null) {
      buf
        ..writeln('│')
        ..writeln('│ Body: ${_pretty(_sanitize(options.data))}');
    }

    buf.write('└$_h');
    debugPrint(buf.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final sw = response.requestOptions.extra['_sw'] as Stopwatch?;
    final ms = sw != null ? '${sw.elapsedMilliseconds} ms' : '?';

    final buf = StringBuffer()
      ..writeln('┌$_h')
      ..writeln(
        '│ ◀  ${response.statusCode} ${response.statusMessage}'
        '  │  ${response.requestOptions.method} ${response.requestOptions.uri}'
        '  │  $ms',
      )
      ..writeln('│')
      ..writeln('│ Body: ${_pretty(response.data)}')
      ..write('└$_h');

    debugPrint(buf.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buf = StringBuffer()
      ..writeln('┌$_h')
      ..writeln('│ ✖  ERROR  ${err.type.name}')
      ..writeln('│    ${err.requestOptions.method} ${err.requestOptions.uri}')
      ..writeln('│    ${err.message}');

    if (err.response != null) {
      buf
        ..writeln('│    Status : ${err.response?.statusCode}')
        ..writeln('│    Body   : ${_pretty(err.response?.data)}');
    }

    buf.write('└$_h');
    debugPrint(buf.toString());
    handler.next(err);
  }

  // Mask sensitive keys so passwords never appear in logs.
  dynamic _sanitize(dynamic data) {
    if (data is Map<String, dynamic>) {
      return {
        for (final e in data.entries)
          e.key: _isSensitive(e.key) ? '[hidden]' : e.value,
      };
    }
    return data;
  }

  bool _isSensitive(String key) {
    final k = key.toLowerCase();
    return k.contains('password') ||
        k.contains('secret') ||
        k.contains('token') ||
        k.contains('pin');
  }

  String _pretty(dynamic data) {
    try {
      final encoded = const JsonEncoder.withIndent('  ').convert(data);
      // Prefix every line with the border so it aligns with the box.
      return encoded.replaceAll('\n', '\n│    ');
    } catch (_) {
      return data.toString();
    }
  }
}
