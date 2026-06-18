import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_shadows.dart';
import 'app_asset.dart';
import '../../gen/assets.gen.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 64.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppShadows.primary,
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(size * 0.25),
          child: AppAsset(
            path: Assets.logos.caresyncMain.path,
            height: size,
            width: size,
          ),
        ),
      ),
    );
  }
}
