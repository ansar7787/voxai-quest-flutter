import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MeshGradientBackground extends StatelessWidget {
  final List<Color>? colors;
  final bool showLetters;
  const MeshGradientBackground({
    super.key,
    this.colors,
    this.showLetters = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // If colors are provided, use them for the floating alphabets
    final primaryColor = (colors != null && colors!.isNotEmpty)
        ? colors!.first
        : const Color(0xFF2563EB);

    final Color letterColor = primaryColor;

    return Stack(
      children: [
        // 1. Floating Animated Letters (The "Glow" source)
        if (showLetters) ...[
          _AnimatedAlphabet(
            alignment: const Alignment(-0.8, -0.6),
            letter: 'V',
            color: letterColor.withValues(alpha: 0.35),
            duration: const Duration(seconds: 25),
          ),
          _AnimatedAlphabet(
            alignment: const Alignment(0.8, -0.7),
            letter: 'O',
            color: letterColor.withValues(alpha: 0.32),
            duration: const Duration(seconds: 30),
          ),
          _AnimatedAlphabet(
            alignment: const Alignment(0, -0.2),
            letter: 'X',
            fontSize: 220.sp,
            color: letterColor.withValues(alpha: 0.28),
            duration: const Duration(seconds: 35),
          ),
          _AnimatedAlphabet(
            alignment: const Alignment(0.7, 0.6),
            letter: 'A',
            color: letterColor.withValues(alpha: 0.30),
            duration: const Duration(seconds: 40),
          ),
          _AnimatedAlphabet(
            alignment: const Alignment(-0.7, 0.7),
            letter: 'I',
            fontSize: 180.sp,
            color: letterColor.withValues(alpha: 0.25),
            duration: const Duration(seconds: 45),
          ),
        ],

        // 2. Global Blur Layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Container(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.15),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedAlphabet extends StatelessWidget {
  final Alignment alignment;
  final String letter;
  final Color color;
  final Duration duration;
  final double? fontSize;

  const _AnimatedAlphabet({
    required this.alignment,
    required this.letter,
    required this.color,
    required this.duration,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child:
          Text(
                letter,
                style: GoogleFonts.outfit(
                  fontSize: fontSize ?? 320.sp,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(
                begin: const Offset(-40, -40),
                end: const Offset(40, 40),
                duration: duration,
                curve: Curves.easeInOut,
              )
              .rotate(
                begin: -0.1,
                end: 0.1,
                duration: duration * 1.5,
                curve: Curves.easeInOut,
              )
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: duration * 1.2,
                curve: Curves.easeInOut,
              ),
    );
  }
}
