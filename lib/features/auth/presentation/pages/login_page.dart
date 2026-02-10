import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/core/utils/injection_container.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/login_cubit.dart';
import 'package:voxai_quest/core/presentation/widgets/loading_overlay.dart';
import 'package:voxai_quest/core/presentation/widgets/auth_background.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSnackBar(context, 'Login successful!', Colors.green);
          context.go(AppRouter.homeRoute);
        }
        if (state.errorMessage != null) {
          final isWarning = state.errorMessage!.contains('canceled');
          _showSnackBar(
            context,
            state.errorMessage!,
            isWarning ? Colors.orange : Colors.red,
          );
        }
        if (state.successMessage != null) {
          _showSnackBar(context, state.successMessage!, Colors.blue);
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.isSubmitting,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: AuthBackground(
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: isKeyboardOpen
                            ? const ClampingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: isKeyboardOpen
                                ? MediaQuery.of(context).size.height
                                : constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Hero(
                                      tag: 'auth_title',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          'VoxAI Quest',
                                          style: GoogleFonts.outfit(
                                            fontSize: 42.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1F2937),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Your English Learning Adventure',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 48.h),
                                    _EmailInput(),
                                    SizedBox(height: 16.h),
                                    _PasswordInput(formKey: _formKey),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () => context.go(
                                          AppRouter.forgotPasswordRoute,
                                        ),
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Color(0xFF2563EB),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    _LoginButton(formKey: _formKey),
                                    SizedBox(height: 16.h),
                                    _GoogleLoginButton(),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Don't have an account? ",
                                          style: TextStyle(
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              context.go(AppRouter.signupRoute),
                                          child: const Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Color(0xFF2563EB),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Color(0xFF1F2937)),
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            errorStyle: const TextStyle(color: Colors.red),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 20.w,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _PasswordInput({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return TextFormField(
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          obscureText: !state.isPasswordVisible,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            if (formKey.currentState!.validate()) {
              context.read<LoginCubit>().logInWithCredentials();
            }
          },
          style: const TextStyle(color: Color(0xFF1F2937)),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            errorStyle: const TextStyle(color: Colors.red),
            prefixIcon: const Icon(
              Icons.lock_outlined,
              color: Color(0xFF9CA3AF),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF9CA3AF),
              ),
              onPressed: () =>
                  context.read<LoginCubit>().togglePasswordVisibility(),
            ),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 20.w,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const _LoginButton({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isSubmitting
              ? null
              : () {
                  if (formKey.currentState!.validate()) {
                    context.read<LoginCubit>().logInWithCredentials();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 0,
          ),
          child: state.isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Login',
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return OutlinedButton(
          onPressed: state.isSubmitting
              ? null
              : () => context.read<LoginCubit>().logInWithGoogle(),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1F2937),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: state.isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.g_mobiledata, size: 32),
                    SizedBox(width: 8.w),
                    Text(
                      'Sign in with Google',
                      style: GoogleFonts.outfit(fontSize: 16.sp),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
