import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_shadows.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/common/app_network_avatar.dart';
import '../../config/doctor_home_tab_config.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onAccept,
    required this.onDecline,
    required this.onStartConsult,
    required this.onViewDetails,
  });

  final DoctorAppointmentItem appointment;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onStartConsult;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final status = appointment.status;
    final isPending = status == DoctorAppointmentStatus.pending;
    final isOnline = appointment.isVideo;
    final patientName = appointment.patientName;

    final statusColor = status.accentColor;
    final statusIcon = status.icon;

    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_filled_rounded,
                                size: 16,
                                color: AppColors.primaryLight,
                              ),
                              const Gap(6),
                              Text(
                                appointment.timeSlot,
                                style: context.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 12, color: statusColor),
                                const Gap(4),
                                Text(
                                  status.label.toUpperCase(),
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(14),
                      Divider(color: borderColor, height: 1),
                      const Gap(14),

                      Row(
                        children: [
                          AppNetworkAvatar(
                            radius: 22,
                            name: patientName,
                            imageUrl: appointment.avatarUrl,
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patientName,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary,
                                      ),
                                ),
                                const Gap(3),
                                Text(
                                  '${appointment.type} • ${appointment.id}',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  (isOnline
                                          ? AppColors.secondary
                                          : AppColors.success)
                                      .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isOnline
                                  ? Icons.videocam_rounded
                                  : Icons.location_on_rounded,
                              color: isOnline
                                  ? AppColors.secondary
                                  : AppColors.success,
                              size: 18,
                            ),
                          ),
                        ],
                      ),

                      if (isPending) ...[
                        const Gap(18),
                        Row(
                          children: [
                            Expanded(
                              child: _AnimatedActionButton(
                                isPrimary: false,
                                text: 'Decline',
                                color: AppColors.error,
                                onTap: onDecline,
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: _AnimatedActionButton(
                                isPrimary: true,
                                text: 'Accept',
                                color: AppColors.primary,
                                onTap: onAccept,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const Gap(18),
                        Row(
                          children: [
                            Expanded(
                              child: _AnimatedActionButton(
                                isPrimary: false,
                                text: 'View Details',
                                color: textSecondary,
                                onTap: onViewDetails,
                              ),
                            ),
                            if (isOnline) ...[
                              const Gap(12),
                              Expanded(
                                child: _AnimatedActionButton(
                                  isPrimary: true,
                                  text: 'Start Consult',
                                  color: AppColors.success,
                                  onTap: onStartConsult,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  const _AnimatedActionButton({
    required this.isPrimary,
    required this.text,
    required this.color,
    required this.onTap,
  });

  final bool isPrimary;
  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTapDown: (_) => _controller.animateTo(0.95, curve: Curves.easeOut),
      onTapUp: (_) {
        _controller.animateTo(1.0, curve: Curves.easeOut);
        widget.onTap();
      },
      onTapCancel: () => _controller.animateTo(1.0, curve: Curves.easeOut),
      child: ScaleTransition(
        scale: _controller,
        child: widget.isPrimary
            ? Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(
                        alpha: isDark ? 0.15 : 0.3,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              )
            : Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
      ),
    );
  }
}
