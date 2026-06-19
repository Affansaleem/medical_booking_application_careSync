import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.phoneNumber,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
    required super.role,
    required super.isOnboardingCompleted,
    super.onboardingCompletedAt,
    super.doctorSpecialty,
    super.doctorQualifications,
    super.doctorYearsExperience,
    super.doctorClinic,
    super.doctorLicenseNumber,
    super.doctorAvailability,
    super.doctorIsPendingVerification,
    super.dateOfBirth,
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
      fullName: metadata['full_name'] as String? ?? metadata['name'] as String?,
      phoneNumber: metadata['phone_number'] as String?,
      avatarUrl: metadata['avatar_url'] as String?,
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(metadata['updated_at'] as String? ?? ''),
      role: role ?? parsedRole,
      isOnboardingCompleted:
          isOnboardingCompleted ??
          (metadata['is_onboarding_completed'] as bool? ?? false),
      onboardingCompletedAt: DateTime.tryParse(
        metadata['onboarding_completed_at'] as String? ?? '',
      ),
      doctorSpecialty: metadata['doctor_specialty'] as String?,
      doctorQualifications: metadata['doctor_qualifications'] as String?,
      doctorYearsExperience: metadata['doctor_years_experience'] != null
          ? (metadata['doctor_years_experience'] as num).toInt()
          : null,
      doctorClinic: metadata['doctor_clinic'] as String?,
      doctorLicenseNumber: metadata['doctor_license_number'] as String?,
      doctorAvailability:
          metadata['doctor_availability'] as Map<String, dynamic>?,
      doctorIsPendingVerification:
          metadata['doctor_is_pending_verification'] as bool?,
      dateOfBirth: metadata['date_of_birth'] as String?,
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
      fullName: json['full_name'] as String? ?? json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      role: parsedRole,
      isOnboardingCompleted: json['is_onboarding_completed'] as bool? ?? false,
      onboardingCompletedAt: json['onboarding_completed_at'] != null
          ? DateTime.tryParse(json['onboarding_completed_at'] as String)
          : null,
      doctorSpecialty: json['doctor_specialty'] as String?,
      doctorQualifications: json['doctor_qualifications'] as String?,
      doctorYearsExperience: json['doctor_years_experience'] != null
          ? (json['doctor_years_experience'] as num).toInt()
          : null,
      doctorClinic: json['doctor_clinic'] as String?,
      doctorLicenseNumber: json['doctor_license_number'] as String?,
      doctorAvailability: json['doctor_availability'] is Map
          ? Map<String, dynamic>.from(json['doctor_availability'] as Map)
          : null,
      doctorIsPendingVerification:
          json['doctor_is_pending_verification'] as bool?,
      dateOfBirth: json['date_of_birth'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'role': role.value,
      'is_onboarding_completed': isOnboardingCompleted,
      'onboarding_completed_at': onboardingCompletedAt?.toIso8601String(),
      'doctor_specialty': doctorSpecialty,
      'doctor_qualifications': doctorQualifications,
      'doctor_years_experience': doctorYearsExperience,
      'doctor_clinic': doctorClinic,
      'doctor_license_number': doctorLicenseNumber,
      'doctor_availability': doctorAvailability,
      'doctor_is_pending_verification': doctorIsPendingVerification,
      'date_of_birth': dateOfBirth,
    };
  }
}
