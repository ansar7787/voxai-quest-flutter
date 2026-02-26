import 'package:flutter/material.dart';

class GameMapLinePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double thickness;
  final bool isDashed;

  GameMapLinePainter({
    required this.points,
    required this.color,
    this.thickness = 4.0,
    this.isDashed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      // Smooth out the path slightly using quadratic bezier if needed,
      // but for "sticking with line" user usually wants direct connections or simple curves
      path.lineTo(points[i].dx, points[i].dy);
    }

    if (isDashed) {
      _drawDashedPath(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 10.0;
    const dashSpace = 8.0;
    double distance = 0.0;

    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
