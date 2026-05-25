/// Thrown when the server returns a non-2xx response.
class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown specifically on 401 responses (expired / missing token).
class UnauthorizedException extends ServerException {
  const UnauthorizedException([String message = 'Unauthorized'])
    : super(message: message, statusCode: 401);
}

/// Thrown when there is no network connectivity or a connection timeout.
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when reading or writing to a local cache fails.
class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
