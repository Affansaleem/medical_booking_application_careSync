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
import '../widgets/role_selector.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final isLoginMode = ref.read(authLoginModeProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();

    if (!isLoginMode && name.isEmpty) {
      AppToast.showError(context, 'Please enter your name');
      return;
    }

    if (email.isEmpty) {
      AppToast.showError(context, 'Please enter your email');
      return;
    }
    if (!AppHelpers.isValidEmail(email)) {
      AppToast.showError(context, 'Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      AppToast.showError(context, 'Please enter your password');
      return;
    }
    if (password.length < 6) {
      AppToast.showError(
        context,
        'Password must be at least 6 characters long',
      );
      return;
    }

    if (!isLoginMode) {
      if (confirmPassword.isEmpty) {
        AppToast.showError(context, 'Please confirm your password');
        return;
      }
      if (password != confirmPassword) {
        AppToast.showError(context, 'Passwords do not match');
        return;
      }
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);

    if (isLoginMode) {
      authNotifier.signIn(email, password);
    } else {
      final role = ref.read(authRoleProvider);
      authNotifier.signUp(email, password, name, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoginMode = ref.watch(authLoginModeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        AppToast.showSuccess(context, 'Signed in successfully!');
        context.go(AppRoutes.home);
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
                      'CareSync',
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        isLoginMode
                            ? 'Welcome back! Log in to continue your healthcare journey.'
                            : 'Create your account to start managing appointments.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(32),

                    // Main card with animated size transition
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Role selector — sign-up only
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: const Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: RoleSelector(),
                              ),
                              crossFadeState: isLoginMode
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 200),
                            ),

                            // Name field — sign-up only
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: AppTextField(
                                  controller: _nameController,
                                  labelText: 'Full Name',
                                  hintText: 'John Doe',
                                  prefixIcon: Icons.person_outline_rounded,
                                ),
                              ),
                              crossFadeState: isLoginMode
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 200),
                            ),

                            AppTextField.email(
                              controller: _emailController,
                              validator: (value) => null,
                            ),
                            const Gap(16),

                            AppTextField.password(
                              controller: _passwordController,
                              textInputAction: isLoginMode
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              onSubmitted: isLoginMode ? _submit : null,
                              validator: (value) => null,
                            ),

                            // Forgot Password Link — Login Mode only
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push(AppRoutes.forgotPassword);
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              crossFadeState: isLoginMode
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 200),
                            ),

                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: AppTextField.password(
                                  controller: _confirmPasswordController,
                                  labelText: 'Confirm Password',
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: _submit,
                                  validator: (value) => null,
                                ),
                              ),
                              crossFadeState: isLoginMode
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 200),
                            ),
                            const Gap(24),

                            AppButton.primary(
                              onPressed: _submit,
                              text: isLoginMode ? 'Sign In' : 'Create Account',
                              isLoading: authState is AuthLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLoginMode
                              ? "Don't have an account? "
                              : 'Already have an account? ',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(authLoginModeProvider.notifier).state =
                                !isLoginMode;
                          },
                          child: Text(
                            isLoginMode ? 'Sign Up' : 'Log In',
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
