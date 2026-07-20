import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
