import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  AuthCubit(this._repository) : super(const AuthState());

  Future<void> restoreAuthentication() async {
    emit(const AuthState(status: AuthStatus.restoring));
    try {
      final user = await _repository.restore();
      emit(
        user == null
            ? const AuthState.unauthenticated()
            : AuthState(status: AuthStatus.authenticated, user: user),
      );
    } catch (error) {
      emit(
        AuthState.unauthenticated(message: AppException.from(error).message),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (state.status == AuthStatus.submitting) return;
    emit(const AuthState(status: AuthStatus.submitting));
    try {
      final user = await _repository.login(
        email: email.trim(),
        password: password,
      );
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      final failure = AppException.from(error);
      emit(
        AuthState.unauthenticated(
          message: failure.message,
          fieldErrors: failure.fieldErrors,
        ),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }

  Future<void> handleUnauthorized() async {
    await _repository.logout();
    if (!isClosed) {
      emit(
        const AuthState.unauthenticated(
          message: 'Your session has expired. Please sign in again.',
        ),
      );
    }
  }
}
