import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> signup(String email, String password, {String? name});
  Future<void> logout();
}
