import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class GetDoctorAppointmentsUseCase
    implements
        UseCase<
          Either<Failure, List<AppointmentEntity>>,
          GetDoctorAppointmentsParams
        > {
  final AppointmentsRepository repository;

  GetDoctorAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetDoctorAppointmentsParams params,
  ) {
    return repository.getDoctorAppointments(
      doctorId: params.doctorId,
      date: params.date,
      status: params.status,
      appointmentType: params.appointmentType,
    );
  }
}

class GetDoctorAppointmentsParams {
  final String doctorId;
  final String? date;
  final String? status;
  final String? appointmentType;

  const GetDoctorAppointmentsParams({
    required this.doctorId,
    this.date,
    this.status,
    this.appointmentType,
  });
}
