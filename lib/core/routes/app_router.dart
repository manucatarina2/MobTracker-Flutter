import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/create_report_screen.dart';
import '../../presentation/screens/alerts_screen.dart';
import '../../presentation/screens/map_screen.dart';
import '../../presentation/screens/rewards_screen.dart';
import '../../presentation/screens/reports_screen.dart';
import '../../presentation/screens/linhas_screen.dart';

class AppRouter {
  static GoRouter setupRouter() {
    return GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      routes: <GoRoute>[
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (BuildContext context, GoRouterState state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (BuildContext context, GoRouterState state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/create-report',
          name: 'create-report',
          builder: (BuildContext context, GoRouterState state) => const CreateReportScreen(),
        ),
        GoRoute(
          path: '/alerts',
          name: 'alerts',
          builder: (BuildContext context, GoRouterState state) => const AlertsScreen(),
        ),
        GoRoute(
          path: '/map',
          name: 'map',
          builder: (BuildContext context, GoRouterState state) => const MapScreen(),
        ),
        GoRoute(
          path: '/rewards',
          name: 'rewards',
          builder: (BuildContext context, GoRouterState state) => const RewardsScreen(),
        ),
        GoRoute(
          path: '/reports',
          name: 'reports',
          builder: (BuildContext context, GoRouterState state) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/linhas',
          name: 'linhas',
          builder: (context, state) => const LinhasScreen(),
        ),
      ],
    );
  }
}