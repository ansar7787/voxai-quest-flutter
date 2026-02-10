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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.successMessage!,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(16.w),
            ),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(16.w),
            ),
          );
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
                                    Container(
                                      padding: EdgeInsets.all(20.w),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFF3F4F6),
                                      ),
                                      child: Icon(
                                        Icons.lock_reset,
                                        size: 64.sp,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                    Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.outfit(
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1F2937),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'No worries! Enter your email address below and we will send you a code to reset your password.',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        color: const Color(0xFF6B7280),
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 48.h),
                                    TextFormField(
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                        ).hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Email Address',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF9CA3AF),
                                        ),
                                        errorStyle: const TextStyle(
                                          color: Colors.red,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF3F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF2563EB),
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.h,
                                          horizontal: 20.w,
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(height: 32.h),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          final email = _emailController.text
                                              .trim();
                                          context
                                              .read<LoginCubit>()
                                              .forgotPassword(email);
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
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Send Reset Link',
                                        style: GoogleFonts.outfit(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Remember your password? ",
                                          style: TextStyle(
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              context.go(AppRouter.loginRoute),
                                          child: const Text(
                                            'Login',
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
}
