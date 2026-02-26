import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/presentation/themes/level_theme_helper.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/utils/game_helper.dart';

class CategoryGamesPage extends StatelessWidget {
  const CategoryGamesPage({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthBloc>().state;
    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final games = _getGamesForCategory(categoryId);
    final categoryColor = _getCategoryColor(categoryId);
    final categoryIcon = _getCategoryIcon(categoryId);

    return Scaffold(
      body: Stack(
        children: [
          const MeshGradientBackground(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Premium Header
              _buildModernHeader(context, categoryColor, categoryIcon),

              // 2. Bento Grid of Games
              SliverPadding(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.w,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final subtype = games[index];
                    return _buildModernGameCard(context, user, subtype, isDark);
                  }, childCount: games.length),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 80.h)),
            ],
          ),
          // Floating Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            child: _buildBackButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, Color color, IconData icon) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 100.h, 24.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: color.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 28.r),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXPLORE',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: color.withValues(alpha: 0.8),
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      categoryId.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E3A8A), // Pure Blue
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Master your skills with targeted quests designed to boost your efficiency in $categoryId.",
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: GlassTile(
        width: 45.r,
        height: 45.r,
        borderRadius: BorderRadius.circular(15.r),
        padding: EdgeInsets.zero,
        child: Icon(
          Icons.chevron_left_rounded,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
          size: 28.r,
        ),
      ),
    );
  }

  Widget _buildModernGameCard(
    BuildContext context,
    UserEntity user,
    GameSubtype subtype,
    bool isDark,
  ) {
    final theme = LevelThemeHelper.getTheme(subtype.name, isDark: isDark);
    final progressVal = user.categoryStats[subtype.name] ?? 0;
    final currentLevel = user.unlockedLevels[subtype.name] ?? 1;

    return GlassTile(
      borderRadius: BorderRadius.circular(32.r),
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(
              '${AppRouter.levelsRoute}?category=$categoryId&gameType=${subtype.name}',
            );
          },
          borderRadius: BorderRadius.circular(32.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Progress Ring
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        GameHelper.getIconForSubtype(subtype),
                        color: theme.primaryColor,
                        size: 22.r,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 32.r,
                          height: 32.r,
                          child: CircularProgressIndicator(
                            value: progressVal / 100,
                            strokeWidth: 3.r,
                            backgroundColor: theme.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          '${progressVal.toInt()}',
                          style: GoogleFonts.outfit(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w900,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Text info
                Text(
                  theme.title,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.05,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'LEVEL $currentLevel',
                    style: GoogleFonts.outfit(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white38 : Colors.black38,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<GameSubtype> _getGamesForCategory(String category) {
    return GameSubtype.values
        .where((s) => s.category.name == category && !s.isLegacy)
        .toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'speaking':
        return const Color(0xFF2563EB); // Royal Blue
      case 'reading':
        return const Color(0xFF6366F1); // Indigo Blue
      case 'writing':
        return const Color(0xFF0EA5E9); // Sky Blue
      case 'grammar':
        return const Color(0xFF3B82F6); // Blue
      case 'listening':
        return const Color(0xFF06B6D4); // Cyan Blue
      case 'accent':
        return const Color(0xFF60A5FA); // Soft Blue
      case 'roleplay':
        return const Color(0xFF0284C7); // Marine Blue
      case 'vocabulary':
        return const Color(0xFF1D4ED8); // Deep Blue
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'speaking':
        return Icons.mic_rounded;
      case 'reading':
        return Icons.menu_book_rounded;
      case 'writing':
        return Icons.edit_note_rounded;
      case 'grammar':
        return Icons.spellcheck_rounded;
      case 'listening':
        return Icons.headphones_rounded;
      case 'accent':
        return Icons.graphic_eq_rounded;
      case 'roleplay':
        return Icons.people_rounded;
      case 'vocabulary':
        return Icons.ads_click_rounded;
      default:
        return Icons.gamepad_rounded;
    }
  }
}
