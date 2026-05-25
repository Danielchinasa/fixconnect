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
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;

  @override
  List<Object?> get props => [id, email, role];
}
