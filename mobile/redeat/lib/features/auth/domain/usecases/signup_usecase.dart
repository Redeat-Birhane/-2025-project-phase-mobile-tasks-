import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<User> call({required String email, required String password, String? name}) {
    return repository.signup(email: email, password: password, name: name);
  }
}
