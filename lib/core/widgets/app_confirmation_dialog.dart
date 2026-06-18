import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_shadows.dart';
import 'app_button.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color? iconColor;
  final bool isDangerous;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.icon = Icons.help_outline_rounded,
    this.iconColor,
    this.isDangerous = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData icon = Icons.help_outline_rounded,
    Color? iconColor,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        isDangerous: isDangerous,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    final Color activeColor = isDangerous ? AppColors.error : AppColors.primary;

    final Color resolvedIconColor = iconColor ?? activeColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isDark ? AppShadows.dialogDark : AppShadows.dialogLight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon header
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: resolvedIconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: resolvedIconColor, size: 28),
                ),
              ),
              const Gap(16),

              // Title
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(10),

              // Content
              Text(
                content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),

              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: AppButton.outlined(
                      onPressed: () => context.pop(false),
                      text: cancelText,
                      height: 48,
                    ),
                  ),
                  const Gap(12),

                  // Confirm Button
                  Expanded(
                    child: isDangerous
                        ? AppButton.danger(
                            onPressed: () => context.pop(true),
                            text: confirmText,
                            height: 48,
                          )
                        : AppButton.primary(
                            onPressed: () => context.pop(true),
                            text: confirmText,
                            height: 48,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
