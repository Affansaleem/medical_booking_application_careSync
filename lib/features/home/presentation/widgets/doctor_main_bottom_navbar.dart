import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../config/doctor_main_page_config.dart';

class DoctorMainBottomNavbar extends StatelessWidget {
  const DoctorMainBottomNavbar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onChanged,
    required this.isDark,
  });

  final List<DoctorMainTabConfig> tabs;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
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
                for (var index = 0; index < tabs.length; index++)
                  _DoctorMainNavItem(
                    isSelected: currentIndex == index,
                    icon: tabs[index].icon,
                    label: tabs[index].label,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onTap: () => onChanged(index),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorMainNavItem extends StatelessWidget {
  const _DoctorMainNavItem({
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final bool isSelected;
  final IconData icon;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Row(
                      children: [
                        const Gap(8),
                        Text(
                          label,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: activeColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
