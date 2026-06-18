import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  /// Colorized shadow for primary buttons and brand elements
  static List<BoxShadow> get primary => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  /// Default shadow for card layouts — light mode
  static List<BoxShadow> get cardLight => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  /// Default shadow for card layouts — dark mode
  static List<BoxShadow> get cardDark => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  /// Spread/soft shadow for major cards like login/register or modals — light mode
  static List<BoxShadow> get dialogLight => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 100,
      offset: const Offset(0, 10),
    ),
  ];

  /// Spread/soft shadow for major cards like login/register or modals — dark mode
  static List<BoxShadow> get dialogDark => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 100,
      offset: const Offset(0, 10),
    ),
  ];

  /// Low elevation shadow for toasts and tooltips
  static List<BoxShadow> get toast => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
