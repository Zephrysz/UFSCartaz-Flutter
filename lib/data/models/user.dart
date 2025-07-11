import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'email')
  final String email;
  
  @ColumnInfo(name: 'password_hash')
  final String passwordHash;
  
  @ColumnInfo(name: 'avatar_url')
  final String? avatarUrl;
  
  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;
  
  @ColumnInfo(name: 'updated_at')
  final DateTime updatedAt;
  
  User({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;
  
  @override
  int get hashCode => id.hashCode ^ email.hashCode;
  
  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }
} 