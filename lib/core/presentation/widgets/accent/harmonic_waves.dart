import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class HarmonicWaves extends StatelessWidget {
  final Color color;
  const HarmonicWaves({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(3, (index) {
        return Positioned(
          bottom: -50.h + (index * 20.h),
          left: -100.w,
          right: -100.w,
          child:
              Opacity(
                    opacity: 0.1 - (index * 0.02),
                    child: CustomPaint(
                      size: Size(1.2.sw, 200.h),
                      painter: WavePainter(
                        color: color,
                        phase: index * math.pi / 4,
                        frequency: 1 + (index * 0.5),
                      ),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .moveX(
                    begin: -50.w,
                    end: 50.w,
                    duration: (3000 + index * 1000).ms,
                    curve: Curves.easeInOutSine,
                  ),
        );
      }),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final double phase;
  final double frequency;

  WavePainter({
    required this.color,
    required this.phase,
    required this.frequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height / 2 +
            math.sin((i / size.width * 2 * math.pi * frequency) + phase) * 50,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
