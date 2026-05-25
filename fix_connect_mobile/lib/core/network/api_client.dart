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
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
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
        return const NetworkException();
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
