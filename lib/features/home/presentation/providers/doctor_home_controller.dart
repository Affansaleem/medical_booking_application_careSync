import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../appointments/domain/usecases/get_doctor_appointments_usecase.dart';
import '../../../appointments/presentation/providers/appointments_providers.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/utils/helpers.dart';
import '../config/doctor_home_tab_config.dart';

class DoctorHomeController
    extends StateNotifier<AsyncValue<DoctorHomeTabData>> {
  final GetDoctorAppointmentsUseCase getDoctorAppointmentsUseCase;
  final AuthState authState;

  DoctorHomeController({
    required this.getDoctorAppointmentsUseCase,
    required this.authState,
  }) : super(const AsyncLoading());

  Future<void> loadDashboardData() async {
    if (authState is! AuthAuthenticated) {
      state = AsyncError(
        StateError('User is not authenticated'),
        StackTrace.current,
      );
      return;
    }

    final user = (authState as AuthAuthenticated).user;
    final doctorId = user.id;

    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    AppHelpers.log(
      'Fetching appointments for Doctor: $doctorId on Date: $dateStr',
      name: 'DoctorHomeTab',
    );

    state = const AsyncLoading();

    final result = await getDoctorAppointmentsUseCase(
      GetDoctorAppointmentsParams(doctorId: doctorId, date: dateStr),
    );

    result.fold(
      (failure) {
        AppHelpers.log(
          'Fetch failed: ${failure.message}',
          name: 'DoctorHomeTab',
        );
        state = AsyncError(failure.message, StackTrace.current);
      },
      (entities) {
        AppHelpers.log(
          'Fetch succeeded. Returned ${entities.length} appointments from DB.',
          name: 'DoctorHomeTab',
        );
        for (var entity in entities) {
          AppHelpers.log(
            'Appointment ID: ${entity.id} | Date: ${entity.appointmentDate} | Start Time: ${entity.startTime} | Status: ${entity.status} | Patient: ${entity.patientName}',
            name: 'DoctorHomeTab',
          );
        }
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
            );
          }).toList();

          final metrics = [
            DoctorDashboardMetric(
              title: "Today's Appointments",
              value: mappedItems.length.toString(),
              icon: Icons.calendar_month_rounded,
              color: AppColors.secondary,
            ),
            DoctorDashboardMetric(
              title: 'Pending Requests',
              value: mappedItems
                  .where(
                    (item) => item.status == DoctorAppointmentStatus.pending,
                  )
                  .length
                  .toString(),
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
            ),
            DoctorDashboardMetric(
              title: 'Completed Today',
              value: mappedItems
                  .where(
                    (item) => item.status == DoctorAppointmentStatus.completed,
                  )
                  .length
                  .toString(),
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.success,
            ),
          ];

          final nextAppointment = mappedItems.firstWhere(
            (item) => item.status == DoctorAppointmentStatus.confirmed,
            orElse: () => const DoctorAppointmentItem(
              id: '',
              patientName: '',
              initials: '',
              timeSlot: '',
              status: DoctorAppointmentStatus.confirmed,
              notes: '',
            ),
          );

          final confirmedAppointments = mappedItems
              .where((item) => item.status == DoctorAppointmentStatus.confirmed)
              .toList();

          final doctorName = _normalizeDoctorName(user.fullName);
          final specialty = user.doctorSpecialty ?? 'Medical Specialist';
          final avatarUrl = user.avatarUrl;
          final isPendingVerification =
              user.doctorIsPendingVerification ?? false;

          final dashboardData = DoctorHomeTabData(
            doctorName: doctorName,
            specialty: specialty,
            avatarUrl: avatarUrl,
            isPendingVerification: isPendingVerification,
            metrics: metrics,
            nextAppointment: nextAppointment.id.isEmpty
                ? null
                : nextAppointment,
            schedule: confirmedAppointments,
            scheduleDateLabel: _formatTodayLabel(now),
          );

          state = AsyncValue.data(dashboardData);
        } catch (e, stackTrace) {
          state = AsyncError(e, stackTrace);
        }
      },
    );
  }

  String _normalizeDoctorName(String? name) {
    final resolved = (name == null || name.trim().isEmpty)
        ? 'Doctor'
        : name.trim();
    return resolved.startsWith('Dr.') ? resolved : 'Dr. $resolved';
  }

  String _formatTodayLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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

final doctorHomeControllerProvider =
    StateNotifierProvider.autoDispose<
      DoctorHomeController,
      AsyncValue<DoctorHomeTabData>
    >((ref) {
      final getDoctorAppointments = ref.watch(
        getDoctorAppointmentsUseCaseProvider,
      );
      final authState = ref.watch(authNotifierProvider);

      final controller = DoctorHomeController(
        getDoctorAppointmentsUseCase: getDoctorAppointments,
        authState: authState,
      );

      controller.loadDashboardData();

      return controller;
    });
