import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
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
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthBloc] LOGIN FAILED -> Error: $e');
      debugPrint('❌ [AuthBloc] StackTrace:\n$stackTrace');
      emit(AuthFailure(message: e.toString()));
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
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthBloc] REGISTER FAILED -> Error: $e');
      debugPrint('❌ [AuthBloc] StackTrace:\n$stackTrace');
      emit(AuthFailure(message: e.toString()));
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
