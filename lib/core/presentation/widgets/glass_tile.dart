import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassTile extends StatelessWidget {
  const GlassTile({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.borderRadius,
    this.glassOpacity,
    this.borderOpacity,
    this.blur,
    this.color,
    this.borderColor,
    this.borderWidth,
  });

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double? glassOpacity;
  final double? borderOpacity;
  final double? blur;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = borderRadius ?? BorderRadius.circular(32.r);
    final sigma = blur ?? 18.0;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color:
            color ??
            (isDark
                ? Colors.white.withValues(alpha: glassOpacity ?? 0.03)
                : Colors.white.withValues(alpha: glassOpacity ?? 0.15)),
        borderRadius: r,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.02),
                ]
              : [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.white.withValues(alpha: 0.1),
                ],
        ),
        border: Border.all(
          color:
              borderColor ??
              (isDark
                  ? Colors.white.withValues(alpha: borderOpacity ?? 0.12)
                  : Colors.white.withValues(alpha: borderOpacity ?? 0.4)),
          width: borderWidth ?? 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}
