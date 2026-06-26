import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';

enum DoctorAppointmentStatus { confirmed, pending, completed }

extension DoctorAppointmentStatusX on DoctorAppointmentStatus {
  String get label {
    switch (this) {
      case DoctorAppointmentStatus.confirmed:
        return 'Confirmed';
      case DoctorAppointmentStatus.pending:
        return 'Pending';
      case DoctorAppointmentStatus.completed:
        return 'Completed';
    }
  }

  Color get accentColor {
    switch (this) {
      case DoctorAppointmentStatus.confirmed:
        return AppColors.success;
      case DoctorAppointmentStatus.pending:
        return AppColors.warning;
      case DoctorAppointmentStatus.completed:
        return AppColors.secondary;
    }
  }

  IconData get icon {
    switch (this) {
      case DoctorAppointmentStatus.confirmed:
        return Icons.verified_rounded;
      case DoctorAppointmentStatus.pending:
        return Icons.hourglass_bottom_rounded;
      case DoctorAppointmentStatus.completed:
        return Icons.check_circle_rounded;
    }
  }
}

class DoctorDashboardMetric {
  const DoctorDashboardMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
}

class DoctorAppointmentItem {
  const DoctorAppointmentItem({
    required this.id,
    required this.patientName,
    required this.initials,
    required this.timeSlot,
    required this.status,
    required this.notes,
    this.avatarUrl,
    this.isVideo = false,
    this.appointmentDate,
    this.type = 'Consultation',
  });

  final String id;
  final String patientName;
  final String initials;
  final String timeSlot;
  final DoctorAppointmentStatus status;
  final String notes;
  final String? avatarUrl;
  final bool isVideo;
  final DateTime? appointmentDate;
  final String type;

  static List<DoctorAppointmentItem> get dummyAppointments => List.generate(
    3,
    (index) => DoctorAppointmentItem(
      id: 'APT-000$index',
      patientName: 'John Doe',
      initials: 'JD',
      timeSlot: '09:00 AM - 09:30 AM',
      status: DoctorAppointmentStatus.pending,
      notes: 'This is a sample patient note for skeleton loading skeletonizer.',
      isVideo: index % 2 == 0,
      appointmentDate: DateTime.now(),
    ),
  );
}

class DoctorHomeTabData {
  const DoctorHomeTabData({
    required this.doctorName,
    required this.specialty,
    required this.avatarUrl,
    required this.isPendingVerification,
    required this.metrics,
    required this.nextAppointment,
    required this.schedule,
    required this.scheduleDateLabel,
  });

  final String doctorName;
  final String specialty;
  final String? avatarUrl;
  final bool isPendingVerification;
  final List<DoctorDashboardMetric> metrics;
  final DoctorAppointmentItem? nextAppointment;
  final List<DoctorAppointmentItem> schedule;
  final String scheduleDateLabel;

  factory DoctorHomeTabData.fromUser(UserEntity user) {
    final doctorName = _normalizeDoctorName(user.fullName);
    final specialty = user.doctorSpecialty ?? 'Medical Specialist';
    final avatarUrl = user.avatarUrl;
    final isPendingVerification = user.doctorIsPendingVerification ?? false;

    const appointments = <DoctorAppointmentItem>[
      DoctorAppointmentItem(
        id: 'APT-1001',
        patientName: 'Sarah Connor',
        initials: 'SC',
        timeSlot: '08:30 AM - 09:00 AM',
        status: DoctorAppointmentStatus.completed,
        notes: 'Follow-up review and BP check',
      ),
      DoctorAppointmentItem(
        id: 'APT-1002',
        patientName: 'David Miller',
        initials: 'DM',
        timeSlot: '09:15 AM - 09:45 AM',
        status: DoctorAppointmentStatus.completed,
        notes: 'Lab report discussion',
      ),
      DoctorAppointmentItem(
        id: 'APT-1003',
        patientName: 'Emma Watson',
        initials: 'EW',
        timeSlot: '10:30 AM - 11:00 AM',
        status: DoctorAppointmentStatus.confirmed,
        notes: 'General check-up and medication review',
        isVideo: true,
      ),
      DoctorAppointmentItem(
        id: 'APT-1004',
        patientName: 'James Cameron',
        initials: 'JC',
        timeSlot: '11:15 AM - 11:45 AM',
        status: DoctorAppointmentStatus.confirmed,
        notes: 'Consultation about test results',
      ),
      DoctorAppointmentItem(
        id: 'APT-1005',
        patientName: 'Olivia Wilde',
        initials: 'OW',
        timeSlot: '12:15 PM - 12:45 PM',
        status: DoctorAppointmentStatus.pending,
        notes: 'Awaiting patient confirmation',
      ),
      DoctorAppointmentItem(
        id: 'APT-1006',
        patientName: 'Bruce Wayne',
        initials: 'BW',
        timeSlot: '01:30 PM - 02:00 PM',
        status: DoctorAppointmentStatus.completed,
        notes: 'Routine consultation',
      ),
      DoctorAppointmentItem(
        id: 'APT-1007',
        patientName: 'Mia Johnson',
        initials: 'MJ',
        timeSlot: '02:15 PM - 02:45 PM',
        status: DoctorAppointmentStatus.pending,
        notes: 'Intake review pending',
      ),
      DoctorAppointmentItem(
        id: 'APT-1008',
        patientName: 'Noah Williams',
        initials: 'NW',
        timeSlot: '03:30 PM - 04:00 PM',
        status: DoctorAppointmentStatus.confirmed,
        notes: 'Video follow-up for recovery progress',
        isVideo: true,
      ),
      DoctorAppointmentItem(
        id: 'APT-1009',
        patientName: 'Ava Brown',
        initials: 'AB',
        timeSlot: '04:15 PM - 04:45 PM',
        status: DoctorAppointmentStatus.pending,
        notes: 'New request awaiting review',
      ),
      DoctorAppointmentItem(
        id: 'APT-1010',
        patientName: 'Lucas Green',
        initials: 'LG',
        timeSlot: '05:00 PM - 05:30 PM',
        status: DoctorAppointmentStatus.completed,
        notes: 'Treatment plan completed',
      ),
    ];

    final metrics = [
      DoctorDashboardMetric(
        title: 'Today\'s Appointments',
        value: appointments.length.toString(),
        icon: Icons.calendar_month_rounded,
        color: AppColors.secondary,
      ),
      DoctorDashboardMetric(
        title: 'Pending Requests',
        value: appointments
            .where((item) => item.status == DoctorAppointmentStatus.pending)
            .length
            .toString(),
        icon: Icons.pending_actions_rounded,
        color: AppColors.warning,
      ),
      DoctorDashboardMetric(
        title: 'Completed Today',
        value: appointments
            .where((item) => item.status == DoctorAppointmentStatus.completed)
            .length
            .toString(),
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.success,
      ),
    ];

    final nextAppointment = appointments.firstWhere(
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

    final confirmedAppointments = appointments
        .where((item) => item.status == DoctorAppointmentStatus.confirmed)
        .toList();

    return DoctorHomeTabData(
      doctorName: doctorName,
      specialty: specialty,
      avatarUrl: avatarUrl,
      isPendingVerification: isPendingVerification,
      metrics: metrics,
      nextAppointment: nextAppointment.id.isEmpty ? null : nextAppointment,
      schedule: confirmedAppointments,
      scheduleDateLabel: _formatTodayLabel(DateTime.now()),
    );
  }
}

String _normalizeDoctorName(String? name) {
  final resolved = (name == null || name.trim().isEmpty)
      ? 'Doctor'
      : name.trim();
  return resolved.startsWith('Dr.') ? resolved : 'Dr. $resolved';
}

class DoctorScheduleConfig {
  DoctorScheduleConfig._();

  static const List<String> monthNames = [
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

  static const List<Map<String, dynamic>> mockAppointments = [
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
}

String _formatTodayLabel(DateTime date) {
  return '${DoctorScheduleConfig.monthNames[date.month - 1]} ${date.day}, ${date.year}';
}
