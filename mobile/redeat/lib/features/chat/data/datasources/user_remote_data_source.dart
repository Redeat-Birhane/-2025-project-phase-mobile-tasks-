import '../../../auth/data/models/user_model.dart';


abstract class UserRemoteDataSource {
  Future<List<UserModel>> fetchAllUsers();
}
