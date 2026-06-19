import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/app_colors.dart';

class AppLoading {
  AppLoading._();

  static Widget threeBounce({
    Color color = AppColors.primary,
    double size = 30.0,
  }) {
    return SpinKitThreeBounce(color: color, size: size);
  }

  static Widget circle({Color color = AppColors.primary, double size = 30.0}) {
    return SpinKitCircle(color: color, size: size);
  }

  static Widget doubleBounce({
    Color color = AppColors.primary,
    double size = 30.0,
  }) {
    return SpinKitDoubleBounce(color: color, size: size);
  }

  static Widget wave({Color color = AppColors.primary, double size = 30.0}) {
    return SpinKitWave(color: color, size: size);
  }

  static Widget fadingCircle({
    Color color = AppColors.primary,
    double size = 30.0,
  }) {
    return SpinKitFadingCircle(color: color, size: size);
  }

  static Widget chasingDots({
    Color color = AppColors.primary,
    double size = 30.0,
  }) {
    return SpinKitChasingDots(color: color, size: size);
  }
}
