import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase
    implements UseCase<Either<Failure, void>, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) {
    return repository.verifyOtp(
      email: params.email,
      token: params.token,
      type: params.type,
    );
  }
}

class VerifyOtpParams {
  final String email;
  final String token;
  final supabase.OtpType type;

  const VerifyOtpParams({
    required this.email,
    required this.token,
    required this.type,
  });
}
