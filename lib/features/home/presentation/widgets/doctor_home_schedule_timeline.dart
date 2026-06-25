import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/common/app_network_avatar.dart';
import '../../../../core/widgets/common/app_empty_state.dart';
import '../config/doctor_home_tab_config.dart';

class DoctorHomeScheduleTimeline extends StatelessWidget {
  const DoctorHomeScheduleTimeline({
    super.key,
    required this.appointments,
    required this.isDark,
  });

  final List<DoctorAppointmentItem> appointments;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Schedule',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(16),
          if (appointments.isEmpty)
            const AppEmptyState(
              icon: Icons.event_busy_rounded,
              title: 'No Appointments Today',
              subtitle: 'Enjoy your free time or check back later.',
            )
          else
            ListView.separated(
              itemCount: appointments.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return _ScheduleTimelineTile(
                  appointment: appointment,
                  isDark: isDark,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ScheduleTimelineTile extends StatelessWidget {
  const _ScheduleTimelineTile({
    required this.appointment,
    required this.isDark,
  });

  final DoctorAppointmentItem appointment;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final timeParts = appointment.timeSlot.split(' - ');
    final startTime = timeParts.isNotEmpty
        ? timeParts.first
        : appointment.timeSlot;
    final endTime = timeParts.length > 1 ? timeParts.last : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  startTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (endTime.isNotEmpty) ...[
                  const Gap(4),
                  Text(
                    endTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            height: 92,
            child: VerticalDivider(
              width: 1,
              thickness: 2,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppNetworkAvatar(
                    radius: 20,
                    name: appointment.patientName,
                    imageUrl: appointment.avatarUrl,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.patientName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          appointment.notes,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Align(
                alignment: Alignment.centerLeft,
                child: _StatusBadge(status: appointment.status),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final DoctorAppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.accentColor),
          const Gap(4),
          Text(
            status.label,
            style: context.textTheme.labelSmall?.copyWith(
              color: status.accentColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
