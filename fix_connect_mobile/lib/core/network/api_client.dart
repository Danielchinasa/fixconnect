import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fix_connect_mobile/core/constants/api_constants.dart';
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

    _authInterceptor = _AuthInterceptor(_dio, tokenStorage);
    _dio.interceptors.add(_authInterceptor);

    if (kDebugMode) {
      _dio.interceptors.add(_PrettyDioLogger());
    }
  }

  late final Dio _dio;
  late final _AuthInterceptor _authInterceptor;

  Dio get dio => _dio;

  /// Called when a 401 cannot be recovered by token refresh.
  /// Typically set to [AuthCubit.logOut] from [main].
  set onSessionExpired(VoidCallback? callback) =>
      _authInterceptor.onSessionExpired = callback;

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
        final body = e.response?.data as Map<String, dynamic>?;
        final raw = body?['message'];
        final message = switch (raw) {
          final List list => list.join(', '),
          final String s => s,
          _ => body?['error'] as String? ?? 'Server error',
        };
        return ServerException(message: message, statusCode: code);
      default:
        return ServerException(message: e.message ?? 'Unknown error');
    }
  }
}

/// Injects the Bearer token on every request and transparently refreshes
/// the access token when a 401 is received, retrying the original request.
/// If the refresh also fails, [onSessionExpired] is called to log the user out.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;
  VoidCallback? onSessionExpired;

  static const _retriedKey = '_retried';

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

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) return handler.next(err);

    // Prevent infinite retry loops.
    if (err.requestOptions.extra.containsKey(_retriedKey)) {
      await _tokenStorage.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }

    try {
      // Use a fresh Dio instance to avoid triggering this interceptor again.
      final freshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: _dio.options.connectTimeout,
          receiveTimeout: _dio.options.receiveTimeout,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final refreshResponse = await freshDio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = refreshResponse.data!;
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String? ?? refreshToken;

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // Retry the original request with the new token.
      final opts = err.requestOptions
        ..extra[_retriedKey] = true
        ..headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch<dynamic>(opts);
      return handler.resolve(retryResponse);
    } catch (_) {
      await _tokenStorage.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }
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
