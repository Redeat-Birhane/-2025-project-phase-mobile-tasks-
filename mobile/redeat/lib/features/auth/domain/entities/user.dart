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
}
