import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/core/usecases/usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase implements UseCase<void, SendOtpParams> {
  const SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(SendOtpParams params) =>
      _repository.sendOtp(email: params.email, purpose: params.purpose);
}

class SendOtpParams extends Equatable {
  const SendOtpParams({required this.email, required this.purpose});

  final String email;

  /// e.g. "VERIFY_EMAIL"
  final String purpose;

  @override
  List<Object?> get props => [email, purpose];
}
