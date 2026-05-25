import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/core/usecases/usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ResetPasswordParams params) => _repository
      .resetPassword(email: params.email, newPassword: params.newPassword);
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.email, required this.newPassword});

  final String email;
  final String newPassword;

  @override
  List<Object?> get props => [email];
}
