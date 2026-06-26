import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../providers/doctor_schedule_provider.dart';

class ScheduleFilterSheet extends ConsumerWidget {
  const ScheduleFilterSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ScheduleFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(doctorScheduleControllerProvider);
    final controller = ref.read(doctorScheduleControllerProvider.notifier);
    final isDark = context.isDark;
    final sheetBg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: borderColor, width: 1.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Appointments',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.resetFilters();
                },
                child: Text(
                  'Reset',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          Text(
            'Status',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const Gap(10),
          Row(
            children: [
              _buildFilterChip(
                context,
                text: 'All',
                isSelected: scheduleState.statusFilter == 'all',
                onTap: () => controller.setStatusFilter('all'),
              ),
              const Gap(8),
              _buildFilterChip(
                context,
                text: 'Confirmed',
                isSelected: scheduleState.statusFilter == 'confirmed',
                onTap: () => controller.setStatusFilter('confirmed'),
              ),
              const Gap(8),
              _buildFilterChip(
                context,
                text: 'Pending',
                isSelected: scheduleState.statusFilter == 'pending',
                onTap: () => controller.setStatusFilter('pending'),
              ),
            ],
          ),
          const Gap(24),
          Text(
            'Method',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const Gap(10),
          Row(
            children: [
              _buildFilterChip(
                context,
                text: 'All Methods',
                isSelected: scheduleState.methodFilter == 'all',
                onTap: () => controller.setMethodFilter('all'),
              ),
              const Gap(8),
              _buildFilterChip(
                context,
                text: 'Video Call',
                isSelected: scheduleState.methodFilter == 'online',
                onTap: () => controller.setMethodFilter('online'),
              ),
              const Gap(8),
              _buildFilterChip(
                context,
                text: 'In-Person',
                isSelected: scheduleState.methodFilter == 'in-person',
                onTap: () => controller.setMethodFilter('in-person'),
              ),
            ],
          ),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
          ),
        ),
      ),
    );
  }
}
