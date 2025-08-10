import '../../../auth/domain/entities/user.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getAllUsers() async {
    final userModels = await remoteDataSource.fetchAllUsers();
    return userModels.map((model) => model.toEntity()).toList();
  }
}
