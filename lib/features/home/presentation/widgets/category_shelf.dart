import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/core/utils/game_helper.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';

class CategoryShelf extends StatelessWidget {
  const CategoryShelf({super.key, required this.user, required this.subtypes});

  final UserEntity user;
  final List<GameSubtype> subtypes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: subtypes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: _GameEntryCard(subtype: subtypes[index]),
          );
        },
      ),
    );
  }
}

class _GameEntryCard extends StatelessWidget {
  const _GameEntryCard({required this.subtype});

  final GameSubtype subtype;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final metadata = GameHelper.getGameMetadata(subtype, isDark: isDark);

    return ScaleButton(
      onTap: () {
        final category = GameHelper.getCategoryForSubtype(subtype);
        context.push(
          '${AppRouter.levelsRoute}?category=$category&gameType=${subtype.name}',
        );
      },
      child: GlassTile(
        width: 150.w,
        borderRadius: BorderRadius.circular(32.r),
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: metadata.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: metadata.color.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(metadata.icon, color: metadata.color, size: 22.r),
                ),
                // Tiny badge or accent
                Container(
                  width: 4.r,
                  height: 4.r,
                  decoration: BoxDecoration(
                    color: metadata.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metadata.title,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  metadata.categoryName.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                    color: metadata.color.withValues(alpha: 0.8),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            // Integrated Bottom Accent
            Container(
              height: 2.h,
              width: 40.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [metadata.color, metadata.color.withValues(alpha: 0)],
                ),
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
