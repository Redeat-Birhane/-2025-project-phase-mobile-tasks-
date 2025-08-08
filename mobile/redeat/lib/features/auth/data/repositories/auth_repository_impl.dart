import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login({required String email, required String password}) async {
    final remoteUser = await remoteDataSource.login(email, password);
    await localDataSource.cacheUser(remoteUser);
    return remoteUser;
  }

  @override
  Future<User> signup({required String email, required String password, String? name}) async {
    final remoteUser = await remoteDataSource.signup(email, password, name: name);
    await localDataSource.cacheUser(remoteUser);
    return remoteUser;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearCache();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await localDataSource.getCachedUser();
    return user != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getCachedUser();
  }
}
