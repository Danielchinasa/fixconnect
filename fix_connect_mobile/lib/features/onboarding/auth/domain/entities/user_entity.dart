import 'package:equatable/equatable.dart';

/// Roles a user can have in the platform.
enum UserRole { customer, artisan }

/// Core domain object representing an authenticated user.
/// Contains no JSON serialisation — that lives in [UserDto].
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.isVerified = false,
    this.createdAt,
    this.bio,
    this.gender,
    this.city,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime? createdAt;
  final String? bio;
  final String? gender;
  final String? city;

  @override
  List<Object?> get props => [id, email, role];
}
