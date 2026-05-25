import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/core/usecases/usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';

class SignupUseCase implements UseCase<void, SignupParams> {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(SignupParams params) => _repository.signup(
    name: params.name,
    email: params.email,
    phone: params.phone,
    password: params.password,
  );
}

class SignupParams extends Equatable {
  const SignupParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String name;
  final String email;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [name, email, phone];
}
