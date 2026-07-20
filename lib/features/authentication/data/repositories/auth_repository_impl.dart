import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Login failed: User object is null');
    }

    return UserModel.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.registerWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Registration failed: User object is null');
    }

    return UserModel.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  UserEntity? getCurrentUser() {
    final firebaseUser = remoteDataSource.getCurrentUser();
    if (firebaseUser == null) {
      return null;
    }
    return UserModel.fromFirebaseUser(firebaseUser);
  }
}
