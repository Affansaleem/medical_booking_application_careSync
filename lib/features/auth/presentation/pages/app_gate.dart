import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/widgets/splash_screen.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../providers/auth_state_provider.dart';
import 'auth_page.dart';
import 'onboarding_page.dart';

class AppGate extends ConsumerWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthError) {
        ref.read(toastServiceProvider.notifier).showError(next.message);
      } else if (next is AuthAuthenticated && next.user.isOnboardingCompleted) {
        AuthState? resolvedPrev = previous;
        while (resolvedPrev is AuthLoading || resolvedPrev is AuthError) {
          if (resolvedPrev is AuthLoading) {
            resolvedPrev = resolvedPrev.previousState;
          } else if (resolvedPrev is AuthError) {
            resolvedPrev = resolvedPrev.previousState;
          } else {
            break;
          }
        }
        if (resolvedPrev is AuthAuthenticated &&
            !resolvedPrev.user.isOnboardingCompleted) {
          ref
              .read(toastServiceProvider.notifier)
              .showSuccess('Profile complete! Welcome to CareSync 🎉');
        }
      }
    });

    AuthState activeState = authState;
    while (activeState is AuthLoading || activeState is AuthError) {
      AuthState? prev;
      if (activeState is AuthLoading) {
        prev = activeState.previousState;
      } else if (activeState is AuthError) {
        prev = activeState.previousState;
      }
      if (prev == null) {
        break;
      }
      activeState = prev;
    }

    if (activeState is AuthLoading || activeState is AuthInitial) {
      return const SplashScreen();
    }

    if (activeState is AuthAuthenticated) {
      if (!activeState.user.isOnboardingCompleted) {
        return const OnboardingPage();
      }
      return const HomePage(title: 'CareSync Home');
    }

    return const AuthPage();
  }
}
