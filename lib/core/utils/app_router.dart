import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voxai_quest/features/auth/presentation/pages/login_page.dart';
import 'package:voxai_quest/features/auth/presentation/pages/signup_page.dart';
import 'package:voxai_quest/features/game/presentation/pages/main_screen.dart';
import 'package:voxai_quest/features/premium/presentation/pages/premium_screen.dart';
import 'package:voxai_quest/features/profile/presentation/pages/profile_screen.dart';
import 'package:voxai_quest/features/settings/presentation/pages/settings_screen.dart';
import 'package:voxai_quest/features/leaderboard/presentation/pages/leaderboard_screen.dart';
import 'package:voxai_quest/features/auth/presentation/pages/forgot_password_page.dart';

import 'package:voxai_quest/core/presentation/widgets/auth_gate.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String gameRoute = '/game';
  static const String premiumRoute = '/premium';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String leaderboardRoute = '/leaderboard';
  static const String forgotPasswordRoute = '/forgot-password';

  static final router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: initialRoute,
        builder: (context, state) => const AuthGate(),
      ),

      GoRoute(path: loginRoute, builder: (context, state) => const LoginPage()),
      GoRoute(
        path: signupRoute,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: forgotPasswordRoute,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(path: homeRoute, builder: (context, state) => const MainScreen()),
      GoRoute(path: gameRoute, builder: (context, state) => const MainScreen()),
      GoRoute(
        path: premiumRoute,
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: profileRoute,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: settingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: leaderboardRoute,
        builder: (context, state) => const LeaderboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri.path}')),
    ),
  );
}
