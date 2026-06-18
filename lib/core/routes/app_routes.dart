import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String login = '/login';
  static const String doctors = '/doctors';
  static const String appointments = '/appointments';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri.path}')),
    ),
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(title: 'CareSync Home'),
      ),
      /*
      // Commented out until Auth, Doctors and Appointments features are implemented
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: doctors,
        builder: (context, state) => const DoctorSearchPage(),
      ),
      GoRoute(
        path: appointments,
        builder: (context, state) => const AppointmentsPage(),
      ),
      */
    ],
  );
}
