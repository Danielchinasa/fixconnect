import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/errors/failures.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';

/// Bridges the domain layer to the remote data source.
/// Catches all infrastructure exceptions and converts them to typed [Failure]s.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<Result<T>> _safeCall<T>(Future<T> Function() call) async {
    try {
      return Ok(await call());
    } on UnauthorizedException {
      return const Err(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Err(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(e.message));
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  // ── AuthRepository ──────────────────────────────────────────────────────────

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) => _safeCall(
    () => _remoteDataSource.login(email: email, password: password),
  );

  @override
  Future<Result<void>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) => _safeCall(
    () => _remoteDataSource.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
    ),
  );

  @override
  Future<Result<UserEntity>> verifyOtp({
    required String email,
    required String otp,
    required String purpose,
  }) => _safeCall(
    () => _remoteDataSource.verifyOtp(email: email, otp: otp, purpose: purpose),
  );

  @override
  Future<Result<void>> resendOtp({
    required String email,
    required String purpose,
  }) => _safeCall(
    () => _remoteDataSource.resendOtp(email: email, purpose: purpose),
  );

  @override
  Future<Result<void>> forgotPassword({required String email}) =>
      _safeCall(() => _remoteDataSource.forgotPassword(email: email));

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String newPassword,
  }) => _safeCall(
    () =>
        _remoteDataSource.resetPassword(email: email, newPassword: newPassword),
  );

  @override
  Future<void> logout() => _remoteDataSource.logout();
}
