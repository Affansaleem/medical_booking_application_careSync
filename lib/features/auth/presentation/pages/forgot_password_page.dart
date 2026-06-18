import 'package:care_sync/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:gap/gap.dart';
import '../providers/auth_state_provider.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/otp_input_field.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOtpSent = false;
  String _pendingPassword = '';

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      AppToast.showError(context, 'Please enter your email');
      return;
    }
    if (!AppHelpers.isValidEmail(email)) {
      AppToast.showError(context, 'Please enter a valid email address');
      return;
    }

    ref.read(authNotifierProvider.notifier).sendPasswordReset(email);
  }

  void _resetPassword() {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (otp.isEmpty) {
      AppToast.showError(context, 'Please enter the verification code');
      return;
    }

    if (password.isEmpty) {
      AppToast.showError(context, 'Please enter a new password');
      return;
    }
    if (password.length < 6) {
      AppToast.showError(
        context,
        'Password must be at least 6 characters long',
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      AppToast.showError(context, 'Please confirm your new password');
      return;
    }
    if (password != confirmPassword) {
      AppToast.showError(context, 'Passwords do not match');
      return;
    }

    _pendingPassword = password;
    ref.read(authNotifierProvider.notifier).verifyOtp(email, otp);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthPasswordResetSent) {
        AppToast.showSuccess(context, 'Verification code sent to your email!');
        setState(() {
          _isOtpSent = true;
        });
      } else if (next is AuthOtpVerified) {
        // OTP verification succeeded, now update the password
        ref
            .read(authNotifierProvider.notifier)
            .updatePassword(_pendingPassword);
      } else if (next is AuthPasswordResetSuccess) {
        AppToast.showSuccess(
          context,
          'Password reset successfully! Log in with your new password.',
        );
        context.go(AppRoutes.login);
      } else if (next is AuthError) {
        AppToast.showError(context, next.message);
      }
    });

    final primaryColor = AppColors.primary;
    final backgroundColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Unified Logo & Header
                    const AppLogo(),
                    const Gap(20),
                    Text(
                      'Reset Password',
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        _isOtpSent
                            ? 'Enter the 6-digit code sent to your email and your new password.'
                            : 'Enter your email address and we will send you a verification code.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(32),

                    // Main card with animated cross fade between Send OTP and Reset Password flows
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: surfaceColor.withValues(
                            alpha: isDark ? 0.85 : 0.95,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: borderColor.withValues(
                              alpha: isDark ? 0.8 : 1.0,
                            ),
                          ),
                          boxShadow: isDark
                              ? AppShadows.dialogDark
                              : AppShadows.dialogLight,
                        ),
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 250),
                          firstCurve: Curves.easeInOut,
                          secondCurve: Curves.easeInOut,
                          crossFadeState: _isOtpSent
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          // Phase 1: Request Code
                          firstChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppTextField.email(
                                controller: _emailController,
                                textInputAction: TextInputAction.done,
                                validator: (value) => null,
                              ),
                              const Gap(24),
                              AppButton.primary(
                                onPressed: _sendOtp,
                                text: 'Send Verification Code',
                                isLoading: authState is AuthLoading,
                              ),
                            ],
                          ),
                          // Phase 2: Enter OTP & New Password
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Verification Code',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              const Gap(8),
                              OtpInputField(
                                onChanged: (value) {
                                  _otpController.text = value;
                                },
                              ),
                              const Gap(16),
                              AppTextField.password(
                                controller: _passwordController,
                                labelText: 'New Password',
                                hintText: '••••••••',
                                textInputAction: TextInputAction.next,
                                validator: (value) => null,
                              ),
                              const Gap(16),
                              AppTextField.password(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm New Password',
                                hintText: '••••••••',
                                textInputAction: TextInputAction.done,
                                onSubmitted: _resetPassword,
                                validator: (value) => null,
                              ),
                              const Gap(24),
                              AppButton.primary(
                                onPressed: _resetPassword,
                                text: 'Reset Password',
                                isLoading: authState is AuthLoading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remembered your password? ',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go(AppRoutes.login);
                          },
                          child: Text(
                            'Log In',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
