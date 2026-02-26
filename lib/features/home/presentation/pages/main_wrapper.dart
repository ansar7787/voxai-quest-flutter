import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
          child:
              GlassTile(
                borderRadius: BorderRadius.circular(24.r),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                glassOpacity: isDark ? 0.1 : 0.6,
                blur: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, 0, Icons.home_rounded, 'HOME'),
                    _buildNavItem(
                      context,
                      1,
                      Icons.leaderboard_rounded,
                      'RANKS',
                    ),
                    _buildNavItem(context, 2, Icons.person_rounded, 'PROFILE'),
                    _buildNavItem(
                      context,
                      3,
                      Icons.settings_rounded,
                      'SETTINGS',
                    ),
                  ],
                ),
              ).animate().slideY(
                begin: 1.0,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = const Color(0xFF3B82F6);

    return GestureDetector(
      onTap: () => _onTap(context, index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                  icon,
                  color: isSelected
                      ? accentColor
                      : (isDark ? Colors.white38 : Colors.black38),
                  size: 24.r,
                )
                .animate(target: isSelected ? 1 : 0)
                .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? accentColor
                    : (isDark ? Colors.white38 : Colors.black38),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
