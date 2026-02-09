import 'package:flutter/material.dart';
import 'package:voxai_quest/features/auth/presentation/pages/login_page.dart';
import 'package:voxai_quest/features/auth/presentation/pages/signup_page.dart';
import 'package:voxai_quest/features/game/presentation/pages/game_screen.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String gameRoute = '/game';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        // AuthGate handles the initial redirection
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case gameRoute:
        return MaterialPageRoute(builder: (_) => const GameScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
