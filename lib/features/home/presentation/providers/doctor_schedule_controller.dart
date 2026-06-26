import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/helpers.dart';
import '../../../appointments/domain/usecases/get_doctor_appointments_usecase.dart';
import '../../../appointments/domain/usecases/update_appointment_status_usecase.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../config/doctor_home_tab_config.dart';
import 'doctor_schedule_state.dart';

class DoctorScheduleController extends StateNotifier<DoctorScheduleState> {
  final GetDoctorAppointmentsUseCase getDoctorAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final AuthState authState;

  DoctorScheduleController({
    required this.getDoctorAppointmentsUseCase,
    required this.updateAppointmentStatusUseCase,
    required this.authState,
  }) : super(
         DoctorScheduleState(
           selectedDate: DateTime.now(),
           weekDays: [],
           statusFilter: 'all',
           methodFilter: 'all',
           appointments: [],
           isLoading: false,
         ),
       ) {
    _generateWeekDays();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) {
      return now.add(Duration(days: index));
    });
    state = state.copyWith(weekDays: weekDays);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    loadAppointments();
  }

  void setStatusFilter(String status) {
    state = state.copyWith(statusFilter: status);
    loadAppointments();
  }

  void setMethodFilter(String method) {
    state = state.copyWith(methodFilter: method);
    loadAppointments();
  }

  void resetFilters() {
    state = state.copyWith(statusFilter: 'all', methodFilter: 'all');
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    if (authState is! AuthAuthenticated) {
      state = state.copyWith(
        errorMessage: 'User is not authenticated',
        isLoading: false,
      );
      return;
    }

    final user = (authState as AuthAuthenticated).user;
    final doctorId = user.id;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final dateStr =
        '${state.selectedDate.year}-${state.selectedDate.month.toString().padLeft(2, '0')}-${state.selectedDate.day.toString().padLeft(2, '0')}';

    final result = await getDoctorAppointmentsUseCase(
      GetDoctorAppointmentsParams(
        doctorId: doctorId,
        date: dateStr,
        status: state.statusFilter,
        appointmentType: state.methodFilter,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (entities) {
        try {
          final mappedItems = entities.map((entity) {
            final patientName = entity.patientName ?? 'Patient';
            return DoctorAppointmentItem(
              id: entity.id,
              patientName: patientName,
              initials: _getInitials(patientName),
              timeSlot: _formatTimeSlot(entity.startTime, entity.endTime),
              status: _mapStatus(entity.status),
              notes:
                  entity.patientNotes ??
                  entity.doctorNotes ??
                  'No notes provided',
              avatarUrl: entity.patientAvatarUrl,
              isVideo:
                  entity.appointmentType.toLowerCase() == 'video' ||
                  entity.appointmentType.toLowerCase() == 'telehealth',
              appointmentDate: entity.appointmentDate,
              type: entity.appointmentType,
            );
          }).toList();

          state = state.copyWith(isLoading: false, appointments: mappedItems);
        } catch (e) {
          state = state.copyWith(isLoading: false, errorMessage: e.toString());
        }
      },
    );
  }

  Future<bool> acceptAppointment(String appointmentId) async {
    final result = await updateAppointmentStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: 'confirmed',
      ),
    );

    return result.fold(
      (failure) {
        AppHelpers.log('Failed to accept appointment: ${failure.message}');
        return false;
      },
      (_) {
        final updatedList = state.appointments.map((apt) {
          if (apt.id == appointmentId) {
            return DoctorAppointmentItem(
              id: apt.id,
              patientName: apt.patientName,
              initials: apt.initials,
              timeSlot: apt.timeSlot,
              status: DoctorAppointmentStatus.confirmed,
              notes: apt.notes,
              avatarUrl: apt.avatarUrl,
              isVideo: apt.isVideo,
              appointmentDate: apt.appointmentDate,
              type: apt.type,
            );
          }
          return apt;
        }).toList();

        state = state.copyWith(appointments: updatedList);
        return true;
      },
    );
  }

  Future<bool> declineAppointment(String appointmentId) async {
    final result = await updateAppointmentStatusUseCase(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        status: 'declined',
      ),
    );

    return result.fold(
      (failure) {
        AppHelpers.log('Failed to decline appointment: ${failure.message}');
        return false;
      },
      (_) {
        final updatedList = state.appointments
            .where((apt) => apt.id != appointmentId)
            .toList();

        state = state.copyWith(appointments: updatedList);
        return true;
      },
    );
  }

  String _formatTimeSlot(String startTimeStr, String endTimeStr) {
    String formatTime(String timeStr) {
      try {
        final parts = timeStr.split(':');
        if (parts.length < 2) return timeStr;
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final isPm = hour >= 12;
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final period = isPm ? 'PM' : 'AM';
        return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
      } catch (e) {
        return timeStr;
      }
    }

    return '${formatTime(startTimeStr)} - ${formatTime(endTimeStr)}';
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'P';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'P';
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  DoctorAppointmentStatus _mapStatus(String dbStatus) {
    switch (dbStatus.toLowerCase()) {
      case 'confirmed':
        return DoctorAppointmentStatus.confirmed;
      case 'completed':
        return DoctorAppointmentStatus.completed;
      case 'pending':
      default:
        return DoctorAppointmentStatus.pending;
    }
  }
}
