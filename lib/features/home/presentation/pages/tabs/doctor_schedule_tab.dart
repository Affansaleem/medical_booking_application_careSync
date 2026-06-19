import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_shadows.dart';

class DoctorScheduleTab extends ConsumerStatefulWidget {
  const DoctorScheduleTab({super.key});

  @override
  ConsumerState<DoctorScheduleTab> createState() => _DoctorScheduleTabState();
}

class _DoctorScheduleTabState extends ConsumerState<DoctorScheduleTab> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _weekDays;

  final List<Map<String, dynamic>> _mockAppointments = [
    {
      'id': 'APT-9821',
      'patientName': 'Sarah Connor',
      'initials': 'SC',
      'time': '09:00 AM - 09:30 AM',
      'type': 'Follow-up',
      'method': 'Video Call',
      'isOnline': true,
      'status': 'confirmed',
      'dateOffset': 0,
    },
    {
      'id': 'APT-4412',
      'patientName': 'David Miller',
      'initials': 'DM',
      'time': '10:15 AM - 10:45 AM',
      'type': 'First Consultation',
      'method': 'In-Person',
      'isOnline': false,
      'status': 'pending',
      'dateOffset': 0,
    },
    {
      'id': 'APT-8711',
      'patientName': 'Emma Watson',
      'initials': 'EW',
      'time': '02:00 PM - 02:30 PM',
      'type': 'General Checkup',
      'method': 'Video Call',
      'isOnline': true,
      'status': 'confirmed',
      'dateOffset': 0,
    },
    {
      'id': 'APT-1090',
      'patientName': 'James Cameron',
      'initials': 'JC',
      'time': '11:00 AM - 11:30 AM',
      'type': 'Consultation',
      'method': 'Video Call',
      'isOnline': true,
      'status': 'pending',
      'dateOffset': 1,
    },
    {
      'id': 'APT-3291',
      'patientName': 'Olivia Wilde',
      'initials': 'OW',
      'time': '03:30 PM - 04:00 PM',
      'type': 'Report Review',
      'method': 'In-Person',
      'isOnline': false,
      'status': 'confirmed',
      'dateOffset': 1,
    },
    {
      'id': 'APT-5561',
      'patientName': 'Bruce Wayne',
      'initials': 'BW',
      'time': '10:00 AM - 10:30 AM',
      'type': 'Physical Therapy',
      'method': 'In-Person',
      'isOnline': false,
      'status': 'confirmed',
      'dateOffset': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _generateWeekDays();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    _weekDays = List.generate(7, (index) {
      return now.add(Duration(days: index));
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Map<String, dynamic>> _getFilteredAppointments() {
    final today = DateTime.now();
    return _mockAppointments.where((apt) {
      final targetDate = today.add(Duration(days: apt['dateOffset'] as int));
      return _isSameDay(_selectedDate, targetDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filteredAppointments = _getFilteredAppointments();

    final months = [
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
    final currentMonth = months[_selectedDate.month - 1];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'My Schedule',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          const Gap(8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentMonth, ${_selectedDate.year}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  'Today',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),

          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _weekDays.length,
              itemBuilder: (context, index) {
                final date = _weekDays[index];
                final isSelected = _isSameDay(date, _selectedDate);
                final dayName = _getDayName(date.weekday);
                final dayNumber = date.day.toString();

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: 62,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      color: isSelected
                          ? null
                          : (isDark ? AppColors.surfaceDark : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                      ),
                      boxShadow: isSelected
                          ? AppShadows.primary
                          : (isDark
                                ? AppShadows.cardDark
                                : AppShadows.cardLight),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.9)
                                : (isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textMutedLight),
                          ),
                        ),
                        const Gap(6),
                        Text(
                          dayNumber,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              height: 1,
            ),
          ),
          const Gap(16),

          Expanded(
            child: filteredAppointments.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 120,
                    ),
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final apt = filteredAppointments[index];
                      return _buildAppointmentCard(context, apt);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 48,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
          ),
          const Gap(16),
          Text(
            'No Appointments',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const Gap(6),
          Text(
            'You are free for this day! No bookings scheduled.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> apt) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final String status = apt['status'] as String;
    final bool isPending = status == 'pending';
    final bool isOnline = apt['isOnline'] as bool;

    Color statusColor = AppColors.success;
    if (isPending) {
      statusColor = AppColors.warning;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
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
                    apt['time'] as String,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(14),

          Divider(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            height: 1,
          ),
          const Gap(14),

          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  apt['initials'] as String,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apt['patientName'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      '${apt['type']} • ${apt['id']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isOnline ? AppColors.secondary : AppColors.success)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isOnline ? Icons.videocam_rounded : Icons.location_on_rounded,
                  color: isOnline ? AppColors.secondary : AppColors.success,
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
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        apt['status'] = 'confirmed';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const Gap(18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isOnline) ...[
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Consult',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
