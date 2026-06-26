import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_shadows.dart';
import '../extensions/context_extensions.dart';
import 'app_button.dart';
import '../../features/home/presentation/config/doctor_home_tab_config.dart';

class AppCalendarPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const AppCalendarPicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppCalendarPicker(
        initialDate: initialDate,
        firstDate:
            firstDate ?? DateTime.now().subtract(const Duration(days: 365 * 5)),
        lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 5)),
      ),
    );
  }

  @override
  State<AppCalendarPicker> createState() => _AppCalendarPickerState();
}

class _AppCalendarPickerState extends State<AppCalendarPicker> {
  late DateTime _selectedDate;
  late DateTime _viewDate;

  final List<String> _weekDayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _monthNames = DoctorScheduleConfig.monthNames;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _viewDate = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
  }

  void _prevMonth() {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month + 1, 1);
    });
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = context.isDark;

    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textMuted = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    // Date math
    final year = _viewDate.year;
    final month = _viewDate.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1 = Mon, 7 = Sun
    final prevMonthDays = DateTime(year, month, 0).day;

    final paddingDays = firstWeekday - 1; // days to show from previous month
    final totalGridCells = 42; // 6 rows * 7 days

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: isDark ? AppShadows.dialogDark : AppShadows.dialogLight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: Month, Year, and navigation arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_monthNames[month - 1]} $year',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      _buildNavigationArrow(
                        icon: Icons.chevron_left_rounded,
                        onPressed: _prevMonth,
                        isDark: isDark,
                      ),
                      const Gap(8),
                      _buildNavigationArrow(
                        icon: Icons.chevron_right_rounded,
                        onPressed: _nextMonth,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(16),

              // Days of week headers (M, T, W...)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _weekDayNames.map((name) {
                  return SizedBox(
                    width: 38,
                    child: Text(
                      name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textMuted,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
              const Gap(8),

              // Calendar Days Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalGridCells,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  DateTime cellDate;
                  bool isCurrentMonth = true;

                  if (index < paddingDays) {
                    final day = prevMonthDays - paddingDays + index + 1;
                    cellDate = DateTime(year, month - 1, day);
                    isCurrentMonth = false;
                  } else if (index < paddingDays + daysInMonth) {
                    final day = index - paddingDays + 1;
                    cellDate = DateTime(year, month, day);
                  } else {
                    final day = index - paddingDays - daysInMonth + 1;
                    cellDate = DateTime(year, month + 1, day);
                    isCurrentMonth = false;
                  }

                  final isSelected = _isSameDay(cellDate, _selectedDate);
                  final isToday = _isSameDay(cellDate, DateTime.now());
                  final isOutOfRange =
                      cellDate.isBefore(widget.firstDate) ||
                      cellDate.isAfter(widget.lastDate);

                  return _buildCalendarDay(
                    context,
                    date: cellDate,
                    isCurrentMonth: isCurrentMonth,
                    isSelected: isSelected,
                    isToday: isToday,
                    isOutOfRange: isOutOfRange,
                    onTap: () {
                      if (!isOutOfRange) {
                        setState(() {
                          _selectedDate = cellDate;
                          // auto-switch month if clicking on padding day
                          if (cellDate.month != _viewDate.month) {
                            _viewDate = DateTime(
                              cellDate.year,
                              cellDate.month,
                              1,
                            );
                          }
                        });
                      }
                    },
                  );
                },
              ),
              const Gap(20),

              // Dialog Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      onPressed: () => context.pop(),
                      text: 'Cancel',
                      height: 44,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: AppButton.primary(
                      onPressed: () => context.pop(_selectedDate),
                      text: 'Select',
                      height: 44,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationArrow({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildCalendarDay(
    BuildContext context, {
    required DateTime date,
    required bool isCurrentMonth,
    required bool isSelected,
    required bool isToday,
    required bool isOutOfRange,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDark;

    Color textColor;
    if (isSelected) {
      textColor = Colors.white;
    } else if (isOutOfRange) {
      textColor = isDark
          ? AppColors.textMutedDark.withValues(alpha: 0.3)
          : AppColors.textMutedLight.withValues(alpha: 0.3);
    } else if (!isCurrentMonth) {
      textColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    } else {
      textColor = isDark
          ? AppColors.textPrimaryDark
          : AppColors.textPrimaryLight;
    }

    return GestureDetector(
      onTap: isOutOfRange ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.primary
              : (isToday
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.transparent),
          border: isToday && !isSelected
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: 1.5,
                )
              : null,
        ),
        child: Text(
          date.day.toString(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: isSelected || isToday
                ? FontWeight.w800
                : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
