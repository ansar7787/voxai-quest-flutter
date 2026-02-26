import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/animated_kids_asset.dart';
import 'package:flutter_animate/flutter_animate.dart';

class KidsFeedbackOverlay extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback onTap;

  const KidsFeedbackOverlay({
    super.key,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: (isCorrect ? Colors.green : Colors.red).withValues(
            alpha: 0.15,
          ),
          child: BackdropFilter(
            filter: ColorFilter.mode(
              (isCorrect ? Colors.green : Colors.red).withValues(alpha: 0.3),
              BlendMode.srcOver,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAnimatedIcon(context),
                  SizedBox(height: 30.h),
                  Text(
                    isCorrect ? "AWESOME!" : "OH NO!",
                    style: GoogleFonts.poppins(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
                  SizedBox(height: 10.h),
                  Text(
                    isCorrect ? "You did it!" : "Let's try one more time",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  SizedBox(height: 50.h),
                  Text(
                        "TAP TO CONTINUE",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2.seconds),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildAnimatedIcon(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final mascotId = authState.user?.kidsMascot ?? "owly";
        final buddyEmoji = mascotId == "owly"
            ? "🦉"
            : (mascotId == "foxie" ? "🦊" : "🦖");

        return Container(
          width: 250.r,
          height: 250.r,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isCorrect ? Colors.green : Colors.red).withValues(
                  alpha: 0.5,
                ),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedKidsAsset(
                  emoji: isCorrect ? '⭐' : '🎈',
                  size: 150.r,
                  animation: isCorrect
                      ? KidsAssetAnimation.bounce
                      : KidsAssetAnimation.hover,
                ),
                if (isCorrect)
                  Positioned(
                    right: -10.r,
                    bottom: -10.r,
                    child: AnimatedKidsAsset(
                      emoji: buddyEmoji,
                      size: 80.r,
                      animation: KidsAssetAnimation.bounce,
                    ).animate().scale(delay: 600.ms, curve: Curves.easeOutBack),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
