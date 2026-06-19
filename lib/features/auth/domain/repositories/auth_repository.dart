import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';
import '../entities/user_role.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String token,
    required supabase.OtpType type,
  });

  Future<Either<Failure, void>> updatePassword({required String newPassword});

  Future<Either<Failure, UserEntity>> completeOnboarding({
    required Map<String, dynamic> onboardingData,
  });

  Stream<supabase.AuthState> get authStateChanges;
}
