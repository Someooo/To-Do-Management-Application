import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<void> call({required String email}) async {
    await repository.sendPasswordResetEmail(email: email);
  }
}
