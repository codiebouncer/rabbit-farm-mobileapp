import 'package:equatable/equatable.dart';
import '../../data/models/auth_user.dart';

enum AuthStatus {
  initial,
  restoring,
  unauthenticated,
  submitting,
  authenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? user;
  final String? message;
  final Map<String, List<String>> fieldErrors;
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
    this.fieldErrors = const {},
  });
  const AuthState.unauthenticated({
    String? message,
    Map<String, List<String>> fieldErrors = const {},
  }) : this(
         status: AuthStatus.unauthenticated,
         message: message,
         fieldErrors: fieldErrors,
       );
  @override
  List<Object?> get props => [status, user, message, fieldErrors];
}
