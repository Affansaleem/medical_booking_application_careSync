import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appointments/presentation/providers/appointments_providers.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../config/doctor_home_tab_config.dart';
import 'doctor_schedule_controller.dart';
import 'doctor_schedule_state.dart';

final doctorScheduleControllerProvider =
    StateNotifierProvider.autoDispose<
      DoctorScheduleController,
      DoctorScheduleState
    >((ref) {
      final getDoctorAppointments = ref.watch(
        getDoctorAppointmentsUseCaseProvider,
      );
      final updateAppointmentStatus = ref.watch(
        updateAppointmentStatusUseCaseProvider,
      );
      final authState = ref.watch(authNotifierProvider);

      final controller = DoctorScheduleController(
        getDoctorAppointmentsUseCase: getDoctorAppointments,
        updateAppointmentStatusUseCase: updateAppointmentStatus,
        authState: authState,
      );

      controller.loadAppointments();

      return controller;
    });

final filteredAppointmentsProvider =
    Provider.autoDispose<List<DoctorAppointmentItem>>((ref) {
      final scheduleState = ref.watch(doctorScheduleControllerProvider);
      return scheduleState.appointments;
    });
