import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/core/network/token_storage.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/dto/user_dto.dart';

/// Contract for remote auth operations.
abstract interface class AuthRemoteDataSource {
  Future<UserDto> login({required String email, required String password});

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String role = 'CUSTOMER',
  });

  Future<UserDto?> verifyOtp({required String email, required String code});

  Future<void> resendOtp({required String email, required String purpose});

  Future<void> sendOtp({required String email, required String purpose});

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<void> logout();
}

/// Concrete implementation — calls the real backend via [ApiClient].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api, this._tokenStorage);

  final ApiClient _api;
  final TokenStorage _tokenStorage;

  @override
  Future<UserDto> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    final data = response.data!;
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    return UserDto.fromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String role = 'CUSTOMER',
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.signup,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        if (phone.isNotEmpty) 'phone': phone,
        'password': password,
        'role': role.toUpperCase(),
      },
    );
    final data = response.data!;
    // Persist tokens so the subsequent OTP-verify call can use them.
    await _tokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  @override
  Future<UserDto?> verifyOtp({
    required String email,
    required String code,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.verifyOtp,
      data: {'email': email, 'code': code},
    );
    final data = response.data ?? {};
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    if (accessToken != null) {
      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
      );
    }
    final userData = data['user'] as Map<String, dynamic>?;
    return userData != null ? UserDto.fromJson(userData) : null;
  }

  @override
  Future<void> resendOtp({
    required String email,
    required String purpose,
  }) async {
    await _api.post<void>(
      ApiConstants.resendOtp,
      data: {'email': email, 'purpose': purpose},
    );
  }

  @override
  Future<void> sendOtp({required String email, required String purpose}) async {
    await _api.post<void>(
      ApiConstants.sendOtp,
      data: {'email': email, 'purpose': purpose},
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _api.post<void>(ApiConstants.forgotPassword, data: {'email': email});
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await _api.post<void>(
      ApiConstants.resetPassword,
      data: {'email': email, 'new_password': newPassword},
    );
  }

  @override
  Future<void> logout() async {
    await _api.post<void>(ApiConstants.logout);
    await _tokenStorage.clear();
  }
}
