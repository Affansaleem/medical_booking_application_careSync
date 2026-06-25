import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppNetworkAvatar extends StatelessWidget {
  const AppNetworkAvatar({
    super.key,
    required this.radius,
    required this.name,
    this.imageUrl,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
  });

  final double radius;
  final String name;
  final String? imageUrl;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final resolvedBackground =
        backgroundColor ??
        (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final resolvedBorderColor =
        borderColor ?? (isDark ? AppColors.borderDark : AppColors.borderLight);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: resolvedBorderColor, width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: resolvedBackground,
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Text(
                _resolveInitials(name),
                style:
                    textStyle ??
                    theme.textTheme.titleSmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w700,
                    ),
              )
            : null,
      ),
    );
  }

  String _resolveInitials(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) {
      return '•';
    }

    final normalized = cleaned.replaceFirst(RegExp(r'^Dr\.\s*'), '');
    final parts = normalized
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return normalized.length >= 2
          ? normalized.substring(0, 2).toUpperCase()
          : normalized.substring(0, 1).toUpperCase();
    }

    if (parts.length == 1) {
      final word = parts.first;
      return word.length >= 2
          ? word.substring(0, 2).toUpperCase()
          : word.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
