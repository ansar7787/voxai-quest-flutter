import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voxai_quest/features/auth/presentation/pages/login_page.dart';
import 'package:voxai_quest/features/auth/presentation/pages/signup_page.dart';
import 'package:voxai_quest/features/auth/presentation/pages/verify_email_page.dart';
import 'package:voxai_quest/features/game/presentation/pages/main_screen.dart';
import 'package:voxai_quest/features/game/presentation/pages/game_screen.dart';
import 'package:voxai_quest/features/premium/presentation/pages/premium_screen.dart';
import 'package:voxai_quest/features/profile/presentation/pages/profile_screen.dart';
import 'package:voxai_quest/features/settings/presentation/pages/settings_screen.dart';
import 'package:voxai_quest/features/leaderboard/presentation/pages/leaderboard_screen.dart';
import 'package:voxai_quest/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:voxai_quest/features/settings/presentation/pages/admin_dashboard.dart';

import 'dart:async';
import 'package:voxai_quest/core/presentation/widgets/auth_gate.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;

class AppRouter {
  static const String initialRoute = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String gameRoute = '/game';
  static const String premiumRoute = '/premium';
  static const String profileRoute = '/profile';
  static const String adminRoute = '/admin';
  static const String settingsRoute = '/settings';
  static const String leaderboardRoute = '/leaderboard';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String verifyEmailRoute = '/verify-email';

  static final router = GoRouter(
    initialLocation: initialRoute,
    refreshListenable: _StreamListenable(di.sl<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = di.sl<AuthBloc>().state;
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isVerified = authState.user?.isEmailVerified ?? false;

      final isLoginRoute = state.uri.path == loginRoute;
      final isSignupRoute = state.uri.path == signupRoute;
      final isForgotPasswordRoute = state.uri.path == forgotPasswordRoute;
      final isAuthRoute =
          isLoginRoute || isSignupRoute || isForgotPasswordRoute;

      if (!isAuthenticated) {
        // If not authenticated and trying to access a protected route, go to login
        if (!isAuthRoute) return loginRoute;
      } else {
        // If authenticated
        if (isAuthRoute) {
          // If on auth pages, go to home or verify email
          return isVerified ? homeRoute : verifyEmailRoute;
        }

        // If authenticated but not verified, and trying to access protected route
        if (!isVerified) {
          // Allow access to verify email page
          if (state.uri.path != verifyEmailRoute) return verifyEmailRoute;
        } else {
          // If verified and trying to access verify email page, go home
          if (state.uri.path == verifyEmailRoute) return homeRoute;
        }
      }
      return null;
    },
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
      GoRoute(
        path: verifyEmailRoute,
        builder: (context, state) => const VerifyEmailPage(),
      ),
      GoRoute(path: homeRoute, builder: (context, state) => const MainScreen()),
      GoRoute(
        path: gameRoute,
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return GameScreen(category: category);
        },
      ),
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
      GoRoute(
        path: adminRoute,
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri.path}')),
    ),
  );
}

class _StreamListenable extends ChangeNotifier {
  final Stream stream;
  late final StreamSubscription subscription;

  _StreamListenable(this.stream) {
    subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
