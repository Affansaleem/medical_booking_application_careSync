import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'app_shimmer_box.dart';
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

    final defaultTextStyle = theme.textTheme.titleSmall?.copyWith(
      color: isDark
          ? AppColors.textSecondaryDark
          : AppColors.textSecondaryLight,
      fontWeight: FontWeight.w700,
    );

    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    Widget? imageWidget;

    if (hasImage) {
      final path = imageUrl!.trim();
      if (path.startsWith('http://') || path.startsWith('https://')) {
        imageWidget = CachedNetworkImage(
          imageUrl: path,
          fit: BoxFit.cover,
          placeholder: (context, url) => AppShimmerBox(
            width: radius * 2,
            height: radius * 2,
            borderRadius: radius,
          ),
          errorWidget: (context, url, error) => Center(
            child: Text(
              _resolveInitials(name),
              style: textStyle ?? defaultTextStyle,
            ),
          ),
        );
      } else if (path.startsWith('assets/')) {
        imageWidget = Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(
              _resolveInitials(name),
              style: textStyle ?? defaultTextStyle,
            ),
          ),
        );
      } else {
        imageWidget = Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(
              _resolveInitials(name),
              style: textStyle ?? defaultTextStyle,
            ),
          ),
        );
      }
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: resolvedBorderColor, width: 2),
        color: resolvedBackground,
      ),
      child: ClipOval(
        child: hasImage
            ? imageWidget
            : Center(
                child: Text(
                  _resolveInitials(name),
                  style: textStyle ?? defaultTextStyle,
                ),
              ),
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
