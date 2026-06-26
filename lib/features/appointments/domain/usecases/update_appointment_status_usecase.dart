import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../repositories/appointments_repository.dart';

class UpdateAppointmentStatusUseCase
    implements UseCase<Either<Failure, void>, UpdateAppointmentStatusParams> {
  final AppointmentsRepository repository;

  UpdateAppointmentStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateAppointmentStatusParams params) {
    return repository.updateAppointmentStatus(
      appointmentId: params.appointmentId,
      status: params.status,
    );
  }
}

class UpdateAppointmentStatusParams {
  final String appointmentId;
  final String status;

  const UpdateAppointmentStatusParams({
    required this.appointmentId,
    required this.status,
  });
}
