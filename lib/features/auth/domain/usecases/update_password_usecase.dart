import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase implements UseCase<Either<Failure, void>, String> {
  final AuthRepository repository;

  UpdatePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String newPassword) {
    return repository.updatePassword(newPassword: newPassword);
  }
}
