import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import 'tabs/doctor_home_tab.dart';
import 'tabs/doctor_schedule_tab.dart';
import 'tabs/doctor_profile_tab.dart';

class DoctorMainPage extends ConsumerStatefulWidget {
  const DoctorMainPage({super.key});

  @override
  ConsumerState<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends ConsumerState<DoctorMainPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DoctorHomeTab(),
    DoctorScheduleTab(),
    DoctorProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _currentIndex, children: _tabs),
      ),
      bottomNavigationBar: _buildGlassNavbar(isDark),
    );
  }

  Widget _buildGlassNavbar(bool isDark) {
    final activeColor = AppColors.primaryLight;
    final inactiveColor = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      decoration: BoxDecoration(
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.surfaceDark : Colors.white).withValues(
                alpha: 0.75,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.08,
                ),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  label: 'Home',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.calendar_month_rounded,
                  label: 'Schedule',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                child: isSelected
                    ? Row(
                        children: [
                          const Gap(8),
                          Text(
                            label,
                            style: TextStyle(
                              color: activeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
