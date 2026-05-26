import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/core/usecases/usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';

class SignupUseCase implements UseCase<void, SignupParams> {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(SignupParams params) => _repository.signup(
    firstName: params.firstName,
    lastName: params.lastName,
    email: params.email,
    phone: params.phone,
    password: params.password,
    role: params.role,
  );
}

class SignupParams extends Equatable {
  const SignupParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone = '',
    this.role = 'CUSTOMER',
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String role;

  @override
  List<Object?> get props => [firstName, lastName, email, phone, role];
}
