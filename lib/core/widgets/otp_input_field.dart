import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../constants/app_colors.dart';

class OtpInputField extends StatelessWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final fillBoxColor = isDark ? AppColors.surfaceDark : Colors.white;

    final defaultPinTheme = PinTheme(
      width: 44,
      height: 54,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      decoration: BoxDecoration(
        color: fillBoxColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
    );

    final submittedPinTheme = defaultPinTheme;

    return Center(
      child: Pinput(
        length: length,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        onChanged: onChanged,
        onCompleted: onCompleted,
        showCursor: true,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
      ),
    );
  }
}
