import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  UserEntity? getCurrentUser();
}
