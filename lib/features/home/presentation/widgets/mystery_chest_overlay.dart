import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

class MysteryChestOverlay extends StatelessWidget {
  const MysteryChestOverlay({
    super.key,
    required this.isOpened,
    required this.rewardAmount,
    required this.onOpen,
    required this.confettiController,
  });

  final bool isOpened;
  final int rewardAmount;
  final VoidCallback onOpen;
  final ConfettiController confettiController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withValues(alpha: 0.85)),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.amber,
                  Colors.orange,
                  Colors.yellow,
                  Colors.white,
                ],
                numberOfParticles: 20,
              ),

              // Title with premium glow
              Text(
                isOpened ? 'CLAIMED!' : 'DAILY MYSTERY',
                style: GoogleFonts.outfit(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: Colors.amber.withValues(alpha: 0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ).animate().fadeIn().scale(
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),

              SizedBox(height: 8.h),

              Text(
                isOpened ? 'TREASURE UNLOCKED' : 'READY TO OPEN?',
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 300.ms),

              SizedBox(height: 50.h),

              GestureDetector(
                onTap: isOpened ? null : onOpen,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dynamic background glow
                    Container(
                          width: 300.r,
                          height: 300.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.amber.withValues(
                                  alpha: isOpened ? 0.3 : 0.1,
                                ),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.2, 1.2),
                          duration: 2.seconds,
                        ),

                    // The Chest Image
                    Image.asset(
                          'assets/images/daily_chest.png', // Assuming user added this
                          width: isOpened ? 280.r : 240.r,
                          height: isOpened ? 280.r : 240.r,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/chest_3d.png',
                              width: isOpened ? 260.r : 220.r,
                              height: isOpened ? 260.r : 220.r,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.card_giftcard_rounded,
                                    size: 150.r,
                                    color: Colors.amber,
                                  ),
                            );
                          },
                        )
                        .animate(
                          onPlay: (c) =>
                              isOpened ? null : c.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(1, 1),
                          end: isOpened
                              ? const Offset(1, 1)
                              : const Offset(1.05, 1.05),
                          duration: 1.seconds,
                          curve: Curves.easeInOut,
                        )
                        .shake(
                          hz: 2,
                          offset: const Offset(2, 0),
                          duration: 2.seconds,
                        )
                        .animate(target: isOpened ? 0 : 1),
                  ],
                ),
              ),

              if (isOpened) ...[
                SizedBox(height: 40.h),

                // Reward Card
                Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.white24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on_rounded,
                            color: Colors.amber,
                            size: 40.r,
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+$rewardAmount',
                                style: GoogleFonts.outfit(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.amber,
                                ),
                              ),
                              Text(
                                'COINS COLLECTED',
                                style: GoogleFonts.outfit(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white70,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideY(begin: 0.5, curve: Curves.easeOutBack),
              ],

              if (!isOpened) ...[
                SizedBox(height: 60.h),
                Text(
                      'TAP TO UNVEIL',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.amber,
                        letterSpacing: 3,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(duration: 1.seconds),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
