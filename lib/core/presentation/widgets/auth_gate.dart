import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/auth/presentation/pages/login_page.dart';
import 'package:voxai_quest/features/game/presentation/pages/main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const MainScreen();
        } else if (state.status == AuthStatus.unauthenticated) {
          return const LoginPage();
        }
        return const Scaffold(
          body: Center(child: ShimmerLoading.circular(width: 50, height: 50)),
        );
      },
    );
  }
}
