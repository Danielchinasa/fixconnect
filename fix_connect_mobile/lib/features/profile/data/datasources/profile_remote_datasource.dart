import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/dto/user_dto.dart';
import 'package:dio/dio.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserDto> getMe();

  Future<UserDto> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? city,
    String? gender,
    String? dateOfBirth,
  });

  Future<String> uploadAvatar({required String filePath});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<UserDto> getMe() async {
    final response = await _api.get<Map<String, dynamic>>(ApiConstants.me);
    return UserDto.fromJson(response.data!);
  }

  @override
  Future<UserDto> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? city,
    String? gender,
    String? dateOfBirth,
  }) async {
    final response = await _api.patch<Map<String, dynamic>>(
      '/users/me',
      data: {
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (bio != null) 'bio': bio,
        if (city != null) 'city': city,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      },
    );
    return UserDto.fromJson(response.data!);
  }

  @override
  Future<String> uploadAvatar({required String filePath}) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    final response = await _api.post<Map<String, dynamic>>(
      '/users/me/avatar',
      data: formData,
    );
    return response.data?['avatarUrl'] as String? ?? '';
  }
}
