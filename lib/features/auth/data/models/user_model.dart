import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    super.createdAt,
    required super.role,
    required super.isOnboardingCompleted,
  });

  factory UserModel.fromSupabase(
    supabase.User user, {
    UserRole? role,
    bool? isOnboardingCompleted,
  }) {
    final metadata = user.userMetadata ?? {};
    final roleValue = metadata['role'] as String? ?? 'patient';
    final parsedRole = UserRole.values.firstWhere(
      (e) => e.value == roleValue,
      orElse: () => UserRole.patient,
    );
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: metadata['name'] as String? ?? metadata['full_name'] as String?,
      avatarUrl:
          metadata['avatar_url'] as String? ?? metadata['photo_url'] as String?,
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      role: role ?? parsedRole,
      isOnboardingCompleted:
          isOnboardingCompleted ??
          (metadata['is_onboarding_completed'] as bool? ?? false),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleValue = json['role'] as String? ?? 'patient';
    final parsedRole = UserRole.values.firstWhere(
      (e) => e.value == roleValue,
      orElse: () => UserRole.patient,
    );
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      avatarUrl: json['photo_url'] as String? ?? json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      role: parsedRole,
      isOnboardingCompleted: json['is_onboarding_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'role': role.value,
      'is_onboarding_completed': isOnboardingCompleted,
    };
  }
}
