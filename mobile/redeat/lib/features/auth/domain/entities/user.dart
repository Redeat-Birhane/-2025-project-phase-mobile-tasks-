class User {
  final String id;
  final String email;
  final String? name;
  String? token;

  User({
    required this.id,
    required this.email,
    this.name,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      token: json['token'] as String?,
    );
  }
}
