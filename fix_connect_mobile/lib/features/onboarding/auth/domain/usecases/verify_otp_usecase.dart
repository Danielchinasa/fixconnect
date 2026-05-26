import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/core/usecases/usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<UserEntity?, VerifyOtpParams> {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity?>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(email: params.email, code: params.code);
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({required this.email, required this.code});

  final String email;
  final String code;

  @override
  List<Object?> get props => [email, code];
}
