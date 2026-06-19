import '../../domain/entities/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  final AuthState? previousState;
  const AuthLoading([this.previousState]);
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  final AuthState? previousState;
  const AuthError(this.message, [this.previousState]);
}

class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}

class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}
