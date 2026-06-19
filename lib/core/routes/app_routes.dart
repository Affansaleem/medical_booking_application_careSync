import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_navigator_key.dart';
import '../../features/auth/presentation/pages/app_gate.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String forgotPassword = '/forgot-password';
  static const String doctors = '/doctors';
  static const String appointments = '/appointments';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: appNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri.path}')),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const AppGate(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
    ],
  );
});
