import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    String? name,
  }) : super(id: id, email: email, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  User toEntity() {
    return User(id: id, email: email, name: name);
  }
}
