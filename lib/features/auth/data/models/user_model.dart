import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
    };
  }

  factory UserModel.fromSupabaseUser(dynamic user, Map<String, dynamic>? metadata) {
    return UserModel(
      id: user.id,
      email: user.email!,
      displayName: metadata?['display_name'] as String?,
      avatarUrl: metadata?['avatar_url'] as String?,
    );
  }
}

