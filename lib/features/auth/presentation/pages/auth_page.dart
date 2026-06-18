import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_asset.dart';
import '../../../../gen/assets.gen.dart';
import 'package:gap/gap.dart';
import '../providers/auth_state_provider.dart';
import '../../../../core/constants/app_shadows.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoginMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (!_isLoginMode && name.isEmpty) {
      AppToast.showError(context, 'Please enter your name');
      return;
    }

    if (email.isEmpty) {
      AppToast.showError(context, 'Please enter your email');
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
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

    final authNotifier = ref.read(authNotifierProvider.notifier);

    if (_isLoginMode) {
      authNotifier.signIn(email, password);
    } else {
      authNotifier.signUp(email, password, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
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
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.secondary.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: AppShadows.primary,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: AppAsset(
                            path: Assets.logos.caresyncMain.path,
                            height: 64,
                            width: 64,
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'CareSync',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        _isLoginMode
                            ? 'Welcome back! Log in to continue your healthcare journey.'
                            : 'Create your account to start managing appointments.',
                        style: theme.textTheme.bodyMedium?.copyWith(
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
                              crossFadeState: _isLoginMode
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
                              onSubmitted: _submit,
                              validator: (value) => null,
                            ),
                            const Gap(24),

                            AppButton.primary(
                              onPressed: _submit,
                              text: _isLoginMode ? 'Sign In' : 'Create Account',
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
                          _isLoginMode
                              ? "Don't have an account? "
                              : 'Already have an account? ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLoginMode = !_isLoginMode;
                            });
                          },
                          child: Text(
                            _isLoginMode ? 'Sign Up' : 'Log In',
                            style: theme.textTheme.bodyMedium?.copyWith(
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
