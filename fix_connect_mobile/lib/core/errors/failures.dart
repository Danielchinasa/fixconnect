import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
/// Use [message] for user-facing error descriptions.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// The server returned an error response.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// No connectivity or the request timed out.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// The access token is missing or expired (HTTP 401).
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Session expired. Please log in again.');
}

/// Local cache read/write failed.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}
