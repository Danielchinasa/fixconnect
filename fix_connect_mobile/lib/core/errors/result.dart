import 'package:fix_connect_mobile/core/errors/failures.dart';

/// A discriminated union representing the outcome of an operation.
///
/// Use pattern-matching (switch/when) to handle both cases:
/// ```dart
/// switch (result) {
///   case Ok(:final value): // success path
///   case Err(:final failure): // error path
/// }
/// ```
sealed class Result<T> {
  const Result();
}

/// The operation succeeded and produced [value].
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// The operation failed with [failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
