import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';

enum ButtonType { primary, secondary, outlined, text }

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final ButtonType type;

  const AppButton.primary({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
  }) : type = ButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
  }) : type = ButtonType.secondary;

  const AppButton.outlined({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
  }) : type = ButtonType.outlined;

  const AppButton.text({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
  }) : type = ButtonType.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = Colors.white;
        break;
      case ButtonType.secondary:
        backgroundColor = AppColors.secondary;
        foregroundColor = Colors.white;
        break;
      case ButtonType.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        break;
    }

    final buttonStyle =
        ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderSide ?? BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ).copyWith(
          // Keep background transparent for text/outlined on disabled states
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled)) {
              if (type == ButtonType.text || type == ButtonType.outlined) {
                return Colors.transparent;
              }
              return AppColors.borderLight;
            }
            return backgroundColor;
          }),
        );

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && !isLoading) ...[Icon(icon, size: 20), const Gap(8)],
        Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    if (isLoading) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null) ? null : onPressed,
        style: buttonStyle,
        child: content,
      ),
    );
  }
}
