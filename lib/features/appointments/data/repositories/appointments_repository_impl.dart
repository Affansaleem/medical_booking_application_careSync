import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_remote_data_source.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;

  AppointmentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getDoctorAppointments({
    required String doctorId,
    String? date,
    String? status,
    String? appointmentType,
  }) async {
    try {
      final appointments = await remoteDataSource.getDoctorAppointments(
        doctorId: doctorId,
        date: date,
        status: status,
        appointmentType: appointmentType,
      );
      return Right(appointments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      await remoteDataSource.updateAppointmentStatus(
        appointmentId: appointmentId,
        status: status,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
