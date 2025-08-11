import '../../../auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers();
}
