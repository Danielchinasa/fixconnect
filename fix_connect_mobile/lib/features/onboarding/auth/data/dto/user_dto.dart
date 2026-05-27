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
    super.isVerified,
    super.createdAt,
    super.bio,
    super.gender,
    super.city,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    // API returns firstName + lastName separately; combine for the domain entity.
    final firstName = (json['firstName'] as String? ?? '').trim();
    final lastName = (json['lastName'] as String? ?? '').trim();
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    return UserDto(
      id: json['id'] as String,
      name: fullName,
      email: json['email'] as String,
      phone: (json['phone'] as String?) ?? '',
      role: _roleFromString(json['role'] as String? ?? 'customer'),
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role.name,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
    'isVerified': isVerified,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (bio != null) 'bio': bio,
    if (gender != null) 'gender': gender,
    if (city != null) 'city': city,
  };

  static UserRole _roleFromString(String value) {
    // API returns uppercase roles e.g. 'CUSTOMER' — normalise before matching.
    final normalised = value.toLowerCase();
    return UserRole.values.firstWhere(
      (r) => r.name == normalised,
      orElse: () => UserRole.customer,
    );
  }
}
