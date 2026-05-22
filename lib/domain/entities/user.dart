/// User entity — domain layer representation.
class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPengunjung => role == 'pengunjung';
  bool get isPetugas => role == 'petugas';
  bool get isAdmin => role == 'admin';

  /// Admin has all petugas privileges.
  bool get canManageBooks => isPetugas || isAdmin;
  bool get canManageLoans => isPetugas || isAdmin;
  bool get canManageUsers => isAdmin;
  bool get canBorrowBooks => isPengunjung;

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
