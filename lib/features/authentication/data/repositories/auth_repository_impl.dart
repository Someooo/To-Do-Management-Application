import 'package:my_template/core/errors/exceptions.dart';
import 'package:my_template/core/errors/failures.dart';
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
    try {
      final credential = await remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthFailure(message: 'Login failed: User object is null');
      }

      return UserModel.fromFirebaseUser(firebaseUser);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthFailure(message: 'Registration failed: User object is null');
      }

      return UserModel.fromFirebaseUser(firebaseUser);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  UserEntity? getCurrentUser() {
    try {
      final firebaseUser = remoteDataSource.getCurrentUser();
      if (firebaseUser == null) {
        return null;
      }
      return UserModel.fromFirebaseUser(firebaseUser);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is AuthException) {
      if (exception.message.toLowerCase().contains('network') ||
          exception.message.toLowerCase().contains('connection')) {
        return NetworkFailure(message: exception.message, cause: exception);
      }
      return AuthFailure(message: exception.message, cause: exception);
    } else if (exception is Failure) {
      return exception;
    } else {
      return ServerFailure(
        message: exception.toString(),
        cause: exception,
      );
    }
  }
}
