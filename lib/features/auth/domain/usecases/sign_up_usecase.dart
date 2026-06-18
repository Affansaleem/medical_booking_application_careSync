import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase
    implements UseCase<Either<Failure, UserEntity>, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
      role: params.role,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String name;
  final UserRole role;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}
