import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/dto/user_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserDto> getMe();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<UserDto> getMe() async {
    final response = await _api.get<Map<String, dynamic>>(ApiConstants.me);
    return UserDto.fromJson(response.data!);
  }
}
