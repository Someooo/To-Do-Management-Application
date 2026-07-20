import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('🔒 [AuthBloc] LOGIN REQUESTED for email: ${event.email}');
    emit(const AuthLoading());
    try {
      debugPrint('🔒 [AuthBloc] Calling LoginUseCase...');
      final user = await _loginUseCase(
        email: event.email,
        password: event.password,
      );
      debugPrint(
          '✅ [AuthBloc] LOGIN SUCCESS -> User ID: ${user.id}, Email: ${user.email}');
      emit(AuthAuthenticated(user: user));
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ [AuthBloc] LOGIN FAILED -> FirebaseAuthException: ${e.code}');
      final errorMessage = _mapFirebaseAuthExceptionToMessage(
        e,
        'Login failed. Please try again.',
      );
      emit(AuthFailure(message: errorMessage));
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthBloc] LOGIN FAILED -> Error: $e');
      debugPrint('❌ [AuthBloc] StackTrace:\n$stackTrace');
      emit(const AuthFailure(message: 'Login failed. Please try again.'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('🔒 [AuthBloc] REGISTER REQUESTED for email: ${event.email}');
    emit(const AuthLoading());
    try {
      debugPrint('🔒 [AuthBloc] Calling RegisterUseCase...');
      final user = await _registerUseCase(
        email: event.email,
        password: event.password,
      );
      debugPrint(
          '✅ [AuthBloc] REGISTER SUCCESS -> User ID: ${user.id}, Email: ${user.email}');
      emit(AuthAuthenticated(user: user));
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ [AuthBloc] REGISTER FAILED -> FirebaseAuthException: ${e.code}');
      final errorMessage = _mapFirebaseAuthExceptionToMessage(
        e,
        'Registration failed. Please try again.',
      );
      emit(AuthFailure(message: errorMessage));
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthBloc] REGISTER FAILED -> Error: $e');
      debugPrint('❌ [AuthBloc] StackTrace:\n$stackTrace');
      emit(const AuthFailure(message: 'Registration failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('🔒 [AuthBloc] LOGOUT REQUESTED');
    try {
      await _logoutUseCase();
      debugPrint('✅ [AuthBloc] LOGOUT SUCCESS');
    } catch (e) {
      debugPrint('⚠️ [AuthBloc] Logout error: $e');
    }
    emit(const AuthUnauthenticated());
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('🔒 [AuthBloc] FORGOT PASSWORD REQUESTED for email: ${event.email}');
    emit(const AuthLoading());
    try {
      await _forgotPasswordUseCase(email: event.email);
      debugPrint('✅ [AuthBloc] FORGOT PASSWORD SUCCESS');
      emit(const AuthPasswordResetEmailSent());
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ [AuthBloc] FirebaseAuthException: ${e.code}');
      final String errorMessage = _mapFirebaseAuthExceptionToMessage(
        e,
        'Failed to send the password reset email. Please try again.',
      );
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      debugPrint('❌ [AuthBloc] Generic error on forgot password: $e');
      emit(const AuthFailure(
          message: 'Failed to send the password reset email. Please try again.'));
    }
  }

  String _mapFirebaseAuthExceptionToMessage(
    FirebaseAuthException e,
    String defaultFallbackMessage,
  ) {
    switch (e.code) {
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No account was found with this email.';
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return defaultFallbackMessage;
    }
  }

  void _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('🔒 [AuthBloc] AUTH CHECK REQUESTED');
    final user = _getCurrentUserUseCase();
    if (user != null) {
      debugPrint(
          '✅ [AuthBloc] User is currently authenticated (ID: ${user.id})');
      emit(AuthAuthenticated(user: user));
    } else {
      debugPrint('ℹ️ [AuthBloc] No user currently authenticated');
      emit(const AuthUnauthenticated());
    }
  }
}
