import '../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getCachedUser();
  Future<void> clearCache();
}
