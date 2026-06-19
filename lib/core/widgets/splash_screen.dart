import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import 'app_loading.dart';
import 'app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 80.0),
            const Gap(16),
            Text(AppConstants.appName, style: theme.textTheme.headlineMedium),
            const Gap(32),
            AppLoading.threeBounce(size: 30.0),
          ],
        ),
      ),
    );
  }
}
