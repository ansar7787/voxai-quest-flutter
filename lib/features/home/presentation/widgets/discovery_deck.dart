import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';

class DiscoveryDeck extends StatefulWidget {
  const DiscoveryDeck({
    super.key,
    required this.user,
    required this.onLaunchQuest,
  });

  final UserEntity user;
  final Function(String) onLaunchQuest;

  @override
  State<DiscoveryDeck> createState() => _DiscoveryDeckState();
}

class _DiscoveryDeckState extends State<DiscoveryDeck> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoveryItems = [
      (
        title: 'For You',
        subtitle: 'Recommended for your progress',
        icon: Icons.lightbulb_outline_rounded,
        color: const Color(0xFF6366F1),
        onTap: () => widget.onLaunchQuest('smart_recommendation'),
      ),
      (
        title: 'Daily Duo',
        subtitle: 'Mixed vocal & reading',
        icon: Icons.auto_awesome_motion_rounded,
        color: const Color(0xFF2563EB),
        onTap: () => widget.onLaunchQuest('daily_duo'),
      ),
      (
        title: 'Speed Blitz',
        subtitle: 'Fast reading challenge',
        icon: Icons.bolt_rounded,
        color: const Color(0xFFF97316),
        onTap: () => widget.onLaunchQuest('speed_blitz'),
      ),
      (
        title: 'Grammar Pro',
        subtitle: 'Elite structural drill',
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF10B981),
        onTap: () => widget.onLaunchQuest('grammar_pro'),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: discoveryItems.length,
            itemBuilder: (context, index) {
              final item = discoveryItems[index];
              final isSelected = _currentPage == index;

              return AnimatedScale(
                scale: isSelected ? 1.0 : 0.9,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: _DiscoveryCollectionCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  color: item.color,
                  onTap: item.onTap,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            discoveryItems.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 6.r,
              width: _currentPage == index ? 24.w : 6.r,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? discoveryItems[index].color
                    : discoveryItems[index].color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscoveryCollectionCard extends StatelessWidget {
  const _DiscoveryCollectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ScaleButton(
      onTap: onTap,
      child: Container(
        height: 180.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: GlassTile(
          borderRadius: BorderRadius.circular(32.r),
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Background Decorative Icon
              Positioned(
                right: -20.w,
                bottom: -20.h,
                child: Icon(
                  icon,
                  size: 160.r,
                  color: color.withValues(alpha: 0.1),
                ),
              ),

              // Content Layer
              Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Tag
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: color.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        title.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                          color: color,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Main Title
                    Expanded(
                      child: Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Action Footer
                    Row(
                      children: [
                        _buildActionMiniChip(color),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.r,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionMiniChip(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bolt_rounded, size: 16.r, color: color),
        SizedBox(width: 4.w),
        Text(
          'START MISSION',
          style: GoogleFonts.outfit(
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
