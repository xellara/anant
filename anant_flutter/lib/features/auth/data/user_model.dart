import 'package:anant_flutter/features/auth/domain/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.username,
    super.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? "Unknown",
      uid: json['uid'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'uid': uid,
    };
  }
}