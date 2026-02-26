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

class BentoArena extends StatelessWidget {
  const BentoArena({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBentoRow(context, [QuestType.speaking, QuestType.reading]),
        SizedBox(height: 12.h),
        _buildBentoRow(context, [QuestType.writing, QuestType.vocabulary]),
        SizedBox(height: 12.h),
        _buildBentoRow(context, [QuestType.grammar, QuestType.listening]),
        SizedBox(height: 12.h),
        _buildBentoRow(context, [QuestType.accent, QuestType.roleplay]),
      ],
    );
  }

  Widget _buildBentoRow(BuildContext context, List<QuestType> types) {
    return Row(
      children: [
        Expanded(
          child: _BentoCategoryTile(type: types[0], user: user),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _BentoCategoryTile(type: types[1], user: user),
        ),
      ],
    );
  }
}

class _BentoCategoryTile extends StatelessWidget {
  const _BentoCategoryTile({required this.type, required this.user});

  final QuestType type;
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getColorForType(type);
    final icon = GameHelper.getIconForCategory(type);
    final progress = _getProgressForType(type);

    return ScaleButton(
      onTap: () =>
          context.push('${AppRouter.categoryGamesRoute}?category=${type.name}'),
      child: GlassTile(
        borderRadius: BorderRadius.circular(24.r),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20.r),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              type.name.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8.h),
            _bentoProgressLine(context, progress, color),
          ],
        ),
      ),
    );
  }

  Widget _bentoProgressLine(
    BuildContext context,
    double progress,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          height: 4.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.08, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4.r,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForType(QuestType type) {
    switch (type) {
      case QuestType.speaking:
        return const Color(0xFF2563EB);
      case QuestType.reading:
        return const Color(0xFF7C3AED);
      case QuestType.writing:
        return const Color(0xFFEC4899);
      case QuestType.vocabulary:
        return const Color(0xFFF97316);
      case QuestType.grammar:
        return const Color(0xFF10B981);
      case QuestType.listening:
        return const Color(0xFF3B82F6);
      case QuestType.accent:
        return const Color(0xFF6366F1);
      case QuestType.roleplay:
        return const Color(0xFFF59E0B);
    }
  }

  double _getProgressForType(QuestType type) {
    switch (type) {
      case QuestType.speaking:
        return user.speakingMastery / 100.0;
      case QuestType.reading:
        return user.readingMastery / 100.0;
      case QuestType.writing:
        return user.writingMastery / 100.0;
      case QuestType.vocabulary:
        return user.vocabularyMastery / 100.0;
      case QuestType.grammar:
        return user.grammarMastery / 100.0;
      case QuestType.listening:
        return user.listeningMastery / 100.0;
      case QuestType.accent:
        return user.accentMastery / 100.0;
      case QuestType.roleplay:
        return user.roleplayMastery / 100.0;
    }
  }
}
