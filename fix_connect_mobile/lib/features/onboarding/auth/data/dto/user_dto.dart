import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';

/// Data Transfer Object for a user returned by the API.
/// Extends [UserEntity] and adds JSON serialisation.
/// The domain entity itself stays free of any serialisation concerns.
class UserDto extends UserEntity {
  const UserDto({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    super.avatarUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: _roleFromString(json['role'] as String? ?? 'customer'),
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role.name,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
  };

  static UserRole _roleFromString(String value) {
    return UserRole.values.firstWhere(
      (r) => r.name == value,
      orElse: () => UserRole.customer,
    );
  }
}
