import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    String? name,
    String? token,
  }) : super(id: id, email: email, name: name, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (name != null) 'name': name,
      if (token != null) 'token': token,
    };
  }
}
