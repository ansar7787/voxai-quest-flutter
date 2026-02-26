import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/core/utils/injection_container.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/login_cubit.dart';
import 'package:voxai_quest/core/presentation/widgets/loading_overlay.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          _showSnackBar(context, state.successMessage!, Colors.blue);
        }
        if (state.errorMessage != null) {
          _showSnackBar(context, state.errorMessage!, Colors.red);
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return LoadingOverlay(
            isLoading: state.isSubmitting,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Stack(
                children: [
                  const MeshGradientBackground(),
                  SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 60.h),
                                    Hero(
                                      tag: 'auth_title',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          'VoxAI Quest',
                                          style: GoogleFonts.outfit(
                                            fontSize: 48.sp,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF2563EB),
                                            letterSpacing: -1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Reset your password',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white54
                                            : const Color(0xFF6B7280),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 48.h),
                                    GlassTile(
                                      padding: EdgeInsets.all(24.r),
                                      borderRadius: BorderRadius.circular(40.r),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16.r),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(
                                                0xFF2563EB,
                                              ).withValues(alpha: 0.1),
                                            ),
                                            child: Icon(
                                              Icons.lock_reset_rounded,
                                              size: 48.r,
                                              color: const Color(0xFF2563EB),
                                            ),
                                          ),
                                          SizedBox(height: 24.h),
                                          Text(
                                            'Enter your email address below and we will send you a link to reset your password.',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14.sp,
                                              color: isDark
                                                  ? Colors.white70
                                                  : const Color(0xFF4B5563),
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 32.h),
                                          TextFormField(
                                            controller: _emailController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your email';
                                              }
                                              if (!RegExp(
                                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                              ).hasMatch(value)) {
                                                return 'Please enter a valid email';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Email Address',
                                              prefixIcon: const Icon(
                                                Icons.email_outlined,
                                              ),
                                              filled: true,
                                              fillColor: isDark
                                                  ? Colors.white10
                                                  : Colors.black.withValues(
                                                      alpha: 0.05,
                                                    ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 24.h),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<LoginCubit>()
                                                    .forgotPassword(
                                                      _emailController.text
                                                          .trim(),
                                                    );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF2563EB,
                                              ),
                                              foregroundColor: Colors.white,
                                              minimumSize: Size(
                                                double.infinity,
                                                56.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                              ),
                                            ),
                                            child: Text(
                                              'Send Reset Link',
                                              style: GoogleFonts.outfit(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Remember your password? ",
                                          style: GoogleFonts.outfit(
                                            color: isDark
                                                ? Colors.white54
                                                : const Color(0xFF6B7280),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              context.go(AppRouter.loginRoute),
                                          child: Text(
                                            'Login',
                                            style: GoogleFonts.outfit(
                                              color: const Color(0xFF2563EB),
                                              fontWeight: FontWeight.w900,
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
                        );
                      },
                    ),
                  ),
                ],
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
