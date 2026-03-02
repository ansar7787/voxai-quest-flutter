import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';

class DailySpinCard extends StatelessWidget {
  const DailySpinCard({super.key, this.margin, required this.onTap});

  final EdgeInsetsGeometry? margin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final lastFreeSpin = user.lastFreeSpinDate;
    bool hasFreeSpin = true;
    if (lastFreeSpin != null) {
      hasFreeSpin =
          !(now.year == lastFreeSpin.year &&
              now.month == lastFreeSpin.month &&
              now.day == lastFreeSpin.day);
    }

    int currentAdSpinsUsed = user.adSpinsUsedToday;
    if (user.lastAdSpinDate != null &&
        !(now.year == user.lastAdSpinDate!.year &&
            now.month == user.lastAdSpinDate!.month &&
            now.day == user.lastAdSpinDate!.day)) {
      currentAdSpinsUsed = 0;
    }

    final maxAdSpins = 3;
    final adSpinsAvailable = maxAdSpins - currentAdSpinsUsed;
    final isAvailable = hasFreeSpin || adSpinsAvailable > 0;

    return ScaleButton(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(
                        Icons.data_usage_rounded,
                        color: Colors.white,
                        size: 32.r,
                      )
                      .animate(onPlay: (c) => isAvailable ? c.repeat() : null)
                      .rotate(duration: 4.seconds),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Fortune Wheel',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    hasFreeSpin
                        ? '1 Free Spin Available!'
                        : adSpinsAvailable > 0
                        ? '$adSpinsAvailable Ad Spins Available'
                        : 'Check back tomorrow',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (isAvailable)
              Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      'SPIN',
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1.05, 1.05),
                    duration: 1.seconds,
                  ),
          ],
        ),
      ),
    );
  }
}
