import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';

/// Base contract for all use cases.
///
/// [Type] — the success value type returned on [Ok].
/// [Params] — the input parameters object (use [NoParams] when not needed).
abstract interface class UseCase<Output, Params> {
  Future<Result<Output>> call(Params params);
}

/// Use this as the [Params] type for use cases that require no input.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
