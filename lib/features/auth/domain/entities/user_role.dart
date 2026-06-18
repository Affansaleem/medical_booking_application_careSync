enum UserRole { patient, doctor }

extension UserRoleX on UserRole {
  String get value => name;
}
