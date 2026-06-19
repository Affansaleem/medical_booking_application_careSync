import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/onboarding_state_provider.dart';
import '../providers/onboarding_config.dart';

class AvailabilityScheduler extends ConsumerWidget {
  const AvailabilityScheduler({super.key});

  Future<void> _selectTime(
    BuildContext context,
    WidgetRef ref,
    String day,
    bool isStartTime,
    TimeOfDay current,
  ) async {
    final picked = await showTimePicker(context: context, initialTime: current);

    if (picked != null) {
      ref
          .read(onboardingFormStateProvider.notifier)
          .updateTime(day, isStartTime, picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingFormStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    final daysOfWeek = OnboardingConfig.daysOfWeek;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Weekly Availability',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const Gap(4),
        Text(
          'Select working days and set active hours.',
          style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
        ),
        const Gap(16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: daysOfWeek.map((day) {
            final isSelected = state.selectedDays.contains(day);
            final isActive = state.activeDay == day;
            return ChoiceChip(
              label: Text(day.substring(0, 3)),
              selected: isSelected,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isActive
                    ? AppColors.primary
                    : (isSelected ? Colors.transparent : borderColor),
                width: isActive ? 2.0 : 1.0,
              ),
              onSelected: (selected) {
                ref.read(onboardingFormStateProvider.notifier).toggleDay(day);
              },
            );
          }).toList(),
        ),
        const Gap(20),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: state.selectedDays.contains(state.activeDay)
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hours for ${state.activeDay}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  if (state.selectedDays.contains(state.activeDay))
                    TextButton.icon(
                      onPressed: () {
                        ref
                            .read(onboardingFormStateProvider.notifier)
                            .applyToAllDays();
                        AppToast.showSuccess(
                          'Applied hours from ${state.activeDay} to all active days!',
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Apply to all'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
              const Gap(16),
              if (state.selectedDays.contains(state.activeDay)) ...[
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(
                          context,
                          ref,
                          state.activeDay,
                          true,
                          state.startTimes[state.activeDay]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Time',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: textSecondary,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                AppFormatters.formatTimeOfDay(
                                  state.startTimes[state.activeDay]!,
                                ),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(
                          context,
                          ref,
                          state.activeDay,
                          false,
                          state.endTimes[state.activeDay]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Time',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: textSecondary,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                AppFormatters.formatTimeOfDay(
                                  state.endTimes[state.activeDay]!,
                                ),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Day is inactive. Select this day to enable working hours.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
