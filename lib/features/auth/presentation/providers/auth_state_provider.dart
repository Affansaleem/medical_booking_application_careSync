import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import 'auth_providers.dart';
import 'auth_state.dart';
export 'auth_state.dart';
export '../../domain/entities/user_role.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.resetPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.updatePasswordUseCase,
  }) : super(const AuthInitial()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    state = const AuthLoading();
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold((failure) => state = AuthError(failure.message), (user) {
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    state = const AuthLoading();
    final result = await signUpUseCase(
      SignUpParams(email: email, password: password, name: name, role: role),
    );
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    final result = await signOutUseCase(const NoParams());
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthUnauthenticated(),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AuthLoading();
    final result = await resetPasswordUseCase(email);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthPasswordResetSent(),
    );
  }

  Future<void> verifyOtp(String email, String token) async {
    state = const AuthLoading();
    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        email: email,
        token: token,
        type: supabase.OtpType.recovery,
      ),
    );
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthOtpVerified(),
    );
  }

  Future<void> updatePassword(String newPassword) async {
    state = const AuthLoading();
    final result = await updatePasswordUseCase(newPassword);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthPasswordResetSuccess(),
    );
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    signInUseCase: ref.watch(signInUseCaseProvider),
    signUpUseCase: ref.watch(signUpUseCaseProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    resetPasswordUseCase: ref.watch(resetPasswordUseCaseProvider),
    verifyOtpUseCase: ref.watch(verifyOtpUseCaseProvider),
    updatePasswordUseCase: ref.watch(updatePasswordUseCaseProvider),
  );
});

final authLoginModeProvider = StateProvider<bool>((ref) => true);

final authRoleProvider = StateProvider<UserRole>((ref) => UserRole.patient);
