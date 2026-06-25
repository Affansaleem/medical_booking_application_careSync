import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/common/app_network_avatar.dart';
import '../../../../core/widgets/common/app_empty_state.dart';
import '../config/doctor_home_tab_config.dart';

class DoctorHomeUpNextCard extends StatelessWidget {
  const DoctorHomeUpNextCard({
    super.key,
    required this.appointment,
    required this.isDark,
    this.onViewDetails,
  });

  final DoctorAppointmentItem? appointment;
  final bool isDark;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    if (appointment == null) {
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
        child: const AppEmptyState(
          icon: Icons.check_circle_outline_rounded,
          title: 'All Done for Today',
          subtitle: 'No more appointments remaining for the rest of today.',
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: isDark ? 0.35 : 0.22),
        ),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Up Next',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(14),
          Row(
            children: [
              AppNetworkAvatar(
                radius: 26,
                name: appointment!.patientName,
                imageUrl: appointment!.avatarUrl,
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment!.patientName,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      appointment!.timeSlot,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      appointment!.isVideo
                          ? Icons.videocam_rounded
                          : Icons.event_rounded,
                      size: 14,
                      color: AppColors.primaryLight,
                    ),
                    const Gap(6),
                    Text(
                      appointment!.isVideo ? 'Video Visit' : 'In Person',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onViewDetails,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  backgroundColor: AppColors.primaryLight.withValues(
                    alpha: 0.08,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'View Details / Notes',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
