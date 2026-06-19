import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CompleteOnboardingUseCase
    implements UseCase<Either<Failure, UserEntity>, Map<String, dynamic>> {
  final AuthRepository repository;

  CompleteOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Map<String, dynamic> params) {
    return repository.completeOnboarding(onboardingData: params);
  }
}
