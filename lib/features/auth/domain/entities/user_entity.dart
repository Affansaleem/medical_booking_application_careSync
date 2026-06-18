class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.createdAt,
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
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, createdAt: $createdAt)';
  }
}
