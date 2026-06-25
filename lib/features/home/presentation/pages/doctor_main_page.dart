import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../config/doctor_main_page_config.dart';
import '../providers/doctor_main_page_provider.dart';
import '../widgets/doctor_main_bottom_navbar.dart';

class DoctorMainPage extends ConsumerWidget {
  const DoctorMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final currentIndex = ref.watch(doctorMainPageIndexProvider);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: currentIndex,
          children: doctorMainTabs.map((tab) => tab.page).toList(),
        ),
      ),
      bottomNavigationBar: DoctorMainBottomNavbar(
        tabs: doctorMainTabs,
        currentIndex: currentIndex,
        isDark: isDark,
        onChanged: (index) =>
            ref.read(doctorMainPageIndexProvider.notifier).state = index,
      ),
    );
  }
}
