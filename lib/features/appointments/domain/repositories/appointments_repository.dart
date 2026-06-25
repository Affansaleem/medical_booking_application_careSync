import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentsRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments({
    required String doctorId,
    String? date,
  });
}
