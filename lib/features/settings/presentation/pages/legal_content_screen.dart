import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LegalContentScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalContentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            pinned: true,
            backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.8),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 20.sp,
                ),
              ),
              centerTitle: true,
            ),
            leading: IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(24.r),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: SelectableText(
                  content,
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 15.sp,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 40.h)),
        ],
      ),
    );
  }
}
