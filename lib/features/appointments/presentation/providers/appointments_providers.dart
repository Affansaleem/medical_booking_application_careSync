import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/appointments_remote_data_source.dart';
import '../../data/repositories/appointments_repository_impl.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../../domain/usecases/get_doctor_appointments_usecase.dart';

final appointmentsRemoteDataSourceProvider =
    Provider<AppointmentsRemoteDataSource>((ref) {
      final client = ref.watch(supabaseClientProvider);
      return AppointmentsRemoteDataSourceImpl(client);
    });

final appointmentsRepositoryProvider = Provider<AppointmentsRepository>((ref) {
  final remoteDataSource = ref.watch(appointmentsRemoteDataSourceProvider);
  return AppointmentsRepositoryImpl(remoteDataSource);
});

final getDoctorAppointmentsUseCaseProvider =
    Provider<GetDoctorAppointmentsUseCase>((ref) {
      final repository = ref.watch(appointmentsRepositoryProvider);
      return GetDoctorAppointmentsUseCase(repository);
    });
