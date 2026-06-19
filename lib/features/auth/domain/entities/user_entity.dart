import 'user_role.dart';

class UserEntity {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserRole role;
  final bool isOnboardingCompleted;
  final DateTime? onboardingCompletedAt;

  final String? doctorSpecialty;
  final String? doctorQualifications;
  final int? doctorYearsExperience;
  final String? doctorClinic;
  final String? doctorLicenseNumber;
  final Map<String, dynamic>? doctorAvailability;
  final bool? doctorIsPendingVerification;

  final String? dateOfBirth;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    required this.role,
    required this.isOnboardingCompleted,
    this.onboardingCompletedAt,
    this.doctorSpecialty,
    this.doctorQualifications,
    this.doctorYearsExperience,
    this.doctorClinic,
    this.doctorLicenseNumber,
    this.doctorAvailability,
    this.doctorIsPendingVerification,
    this.dateOfBirth,
  });

  @Deprecated('Use fullName instead.')
  String? get name => fullName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          fullName == other.fullName &&
          phoneNumber == other.phoneNumber &&
          avatarUrl == other.avatarUrl &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          role == other.role &&
          isOnboardingCompleted == other.isOnboardingCompleted &&
          onboardingCompletedAt == other.onboardingCompletedAt &&
          doctorSpecialty == other.doctorSpecialty &&
          doctorQualifications == other.doctorQualifications &&
          doctorYearsExperience == other.doctorYearsExperience &&
          doctorClinic == other.doctorClinic &&
          doctorLicenseNumber == other.doctorLicenseNumber &&
          doctorAvailability == other.doctorAvailability &&
          doctorIsPendingVerification == other.doctorIsPendingVerification &&
          dateOfBirth == other.dateOfBirth;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      fullName.hashCode ^
      phoneNumber.hashCode ^
      avatarUrl.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      role.hashCode ^
      isOnboardingCompleted.hashCode ^
      onboardingCompletedAt.hashCode ^
      doctorSpecialty.hashCode ^
      doctorQualifications.hashCode ^
      doctorYearsExperience.hashCode ^
      doctorClinic.hashCode ^
      doctorLicenseNumber.hashCode ^
      doctorAvailability.hashCode ^
      doctorIsPendingVerification.hashCode ^
      dateOfBirth.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt, role: $role, isOnboardingCompleted: $isOnboardingCompleted, onboardingCompletedAt: $onboardingCompletedAt, doctorSpecialty: $doctorSpecialty, doctorQualifications: $doctorQualifications, doctorYearsExperience: $doctorYearsExperience, doctorClinic: $doctorClinic, doctorLicenseNumber: $doctorLicenseNumber, doctorAvailability: $doctorAvailability, doctorIsPendingVerification: $doctorIsPendingVerification, dateOfBirth: $dateOfBirth)';
  }
}
