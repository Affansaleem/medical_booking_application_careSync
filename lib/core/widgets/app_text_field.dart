import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.validator,
  }) : isPassword = false;

  const AppTextField._internal({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.obscureText,
    required this.isPassword,
    required this.keyboardType,
    required this.textInputAction,
    this.onSubmitted,
    this.validator,
  });

  factory AppTextField.email({
    Key? key,
    required TextEditingController controller,
    String labelText = 'Email Address',
    String hintText = 'example@email.com',
    TextInputAction textInputAction = TextInputAction.next,
    String? Function(String?)? validator,
  }) {
    return AppTextField._internal(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icons.mail_outline_rounded,
      obscureText: false,
      isPassword: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
    );
  }

  factory AppTextField.password({
    Key? key,
    required TextEditingController controller,
    String labelText = 'Password',
    String hintText = '••••••••',
    TextInputAction textInputAction = TextInputAction.done,
    String? Function(String?)? validator,
    VoidCallback? onSubmitted,
  }) {
    return AppTextField._internal(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: true,
      isPassword: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
    );
  }

  factory AppTextField.search({
    Key? key,
    required TextEditingController controller,
    String labelText = 'Search',
    String hintText = 'Search doctors, specialties...',
    TextInputAction textInputAction = TextInputAction.search,
    ValueChanged<String>? onSubmitted,
    Widget? suffixIcon,
  }) {
    return AppTextField._internal(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icons.search_rounded,
      suffixIcon: suffixIcon,
      obscureText: false,
      isPassword: false,
      keyboardType: TextInputType.text,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textMuted = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final fillBoxColor = isDark ? AppColors.surfaceDark : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const Gap(6),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          style: theme.textTheme.bodyLarge?.copyWith(color: textPrimary),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(color: textMuted),
            prefixIcon: Icon(widget.prefixIcon, color: textMuted),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: textMuted,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            filled: true,
            fillColor: fillBoxColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
