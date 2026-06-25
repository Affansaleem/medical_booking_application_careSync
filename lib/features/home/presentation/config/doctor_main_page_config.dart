import 'package:flutter/material.dart';

import '../pages/tabs/doctor_home_tab.dart';
import '../pages/tabs/doctor_profile_tab.dart';
import '../pages/tabs/doctor_schedule_tab.dart';

class DoctorMainTabConfig {
  const DoctorMainTabConfig({
    required this.icon,
    required this.label,
    required this.page,
  });

  final IconData icon;
  final String label;
  final Widget page;
}

const doctorMainTabs = [
  DoctorMainTabConfig(
    icon: Icons.dashboard_rounded,
    label: 'Home',
    page: DoctorHomeTab(),
  ),
  DoctorMainTabConfig(
    icon: Icons.calendar_month_rounded,
    label: 'Schedule',
    page: DoctorScheduleTab(),
  ),
  DoctorMainTabConfig(
    icon: Icons.person_rounded,
    label: 'Profile',
    page: DoctorProfileTab(),
  ),
];
