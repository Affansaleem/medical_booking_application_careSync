import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/app_toast.dart';
import '../../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../../core/widgets/common/app_empty_state.dart';
import '../../config/doctor_home_tab_config.dart';
import '../../providers/doctor_schedule_provider.dart';
import 'appointment_card.dart';

class ScheduleAppointmentList extends ConsumerWidget {
  const ScheduleAppointmentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAppointments = ref.watch(filteredAppointmentsProvider);
    final scheduleState = ref.watch(doctorScheduleControllerProvider);
    final controller = ref.read(doctorScheduleControllerProvider.notifier);

    if (scheduleState.errorMessage != null) {
      return AppEmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Failed to Load Appointments',
        subtitle: scheduleState.errorMessage!,
        actionText: 'Retry',
        onActionPressed: () => controller.loadAppointments(),
      );
    }

    if (!scheduleState.isLoading && filteredAppointments.isEmpty) {
      return AppEmptyState(
        icon: Icons.event_busy_rounded,
        title: 'No Appointments Found',
        subtitle:
            scheduleState.statusFilter != 'all' ||
                scheduleState.methodFilter != 'all'
            ? 'Try resetting the filters to view all scheduled slots.'
            : 'You have a clear schedule for this day!',
      );
    }

    final displayAppointments = scheduleState.isLoading
        ? DoctorAppointmentItem.dummyAppointments
        : filteredAppointments;

    return Skeletonizer(
      enabled: scheduleState.isLoading,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
        itemCount: displayAppointments.length,
        itemBuilder: (context, index) {
          final apt = displayAppointments[index];
          return AppointmentCard(
            appointment: apt,
            onAccept: () async {
              if (scheduleState.isLoading) return;
              final confirm = await AppConfirmationDialog.show(
                context,
                title: 'Accept Appointment',
                content:
                    'Are you sure you want to accept this appointment with ${apt.patientName}?',
                confirmText: 'Accept',
                icon: Icons.check_circle_rounded,
              );
              if (confirm) {
                final success = await controller.acceptAppointment(apt.id);
                if (success) {
                  AppToast.showSuccess('Appointment accepted successfully');
                } else {
                  AppToast.showError('Failed to accept appointment');
                }
              }
            },
            onDecline: () async {
              if (scheduleState.isLoading) return;
              final confirm = await AppConfirmationDialog.show(
                context,
                title: 'Decline Appointment',
                content:
                    'Are you sure you want to decline this appointment with ${apt.patientName}?',
                confirmText: 'Decline',
                isDangerous: true,
                icon: Icons.cancel_rounded,
              );
              if (confirm) {
                final success = await controller.declineAppointment(apt.id);
                if (success) {
                  AppToast.showSuccess('Appointment declined successfully');
                } else {
                  AppToast.showError('Failed to decline appointment');
                }
              }
            },
            onStartConsult: () async {
              if (scheduleState.isLoading) return;
              final confirm = await AppConfirmationDialog.show(
                context,
                title: 'Start Consultation',
                content:
                    'Do you want to start the video consult with ${apt.patientName} now?',
                confirmText: 'Start',
                icon: Icons.videocam_rounded,
              );
              if (confirm) {
                AppToast.showSuccess(
                  'Starting consult with ${apt.patientName}...',
                );
              }
            },
            onViewDetails: () {
              if (scheduleState.isLoading) return;
              AppToast.showInfo('Viewing details for ${apt.patientName}');
            },
          );
        },
      ),
    );
  }
}
