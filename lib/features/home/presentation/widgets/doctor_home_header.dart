import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/common/app_network_avatar.dart';

class DoctorHomeHeader extends StatelessWidget {
  const DoctorHomeHeader({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.avatarUrl,
  });

  final String doctorName;
  final String specialty;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      children: [
        AppNetworkAvatar(radius: 28, name: doctorName, imageUrl: avatarUrl),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Doctor',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const Gap(2),
              Text(
                doctorName,
                style: context.textTheme.titleLarge?.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Gap(6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  specialty.toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
