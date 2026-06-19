import 'user_role.dart';

class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final UserRole role;
  final bool isOnboardingCompleted;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.createdAt,
    required this.role,
    required this.isOnboardingCompleted,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          createdAt == other.createdAt &&
          role == other.role &&
          isOnboardingCompleted == other.isOnboardingCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      createdAt.hashCode ^
      role.hashCode ^
      isOnboardingCompleted.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, createdAt: $createdAt, role: $role, isOnboardingCompleted: $isOnboardingCompleted)';
  }
}
