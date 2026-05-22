import 'package:library_app/domain/entities/user.dart';

/// User data model — maps API JSON to domain entity.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'pengunjung',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      role: role,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      emailVerifiedAt: user.emailVerifiedAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
