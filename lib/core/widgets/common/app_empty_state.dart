import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../constants/app_colors.dart';
import '../../extensions/context_extensions.dart';
import '../app_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon = Icons.hourglass_empty_rounded,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final resolvedIconColor = iconColor ?? AppColors.secondary;

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: resolvedIconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: resolvedIconColor.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(icon, size: 32, color: resolvedIconColor),
            ),
            const Gap(16),
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const Gap(8),
              Text(
                subtitle!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onActionPressed != null) ...[
              const Gap(20),
              AppButton.primary(onPressed: onActionPressed!, text: actionText!),
            ],
          ],
        ),
      ),
    );
  }
}
