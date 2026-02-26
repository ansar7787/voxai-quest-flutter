import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class QuestSequencePage extends StatefulWidget {
  final String sequenceId;
  final List<GameQuest> quests;

  const QuestSequencePage({
    super.key,
    required this.sequenceId,
    required this.quests,
  });

  @override
  State<QuestSequencePage> createState() => _QuestSequencePageState();
}

class _QuestSequencePageState extends State<QuestSequencePage> {
  int _currentIndex = 0;
  bool _isLaunching = false;

  String get _sequenceTitle {
    switch (widget.sequenceId) {
      case 'daily_duo':
        return 'Daily Duo';
      case 'speed_blitz':
        return 'Speed Blitz';
      case 'grammar_pro':
        return 'Grammar Pro';
      default:
        return 'Themed Quest';
    }
  }

  Future<void> _startNextGame() async {
    if (_currentIndex >= widget.quests.length) {
      _finishSequence();
      return;
    }

    setState(() => _isLaunching = true);
    final quest = widget.quests[_currentIndex];

    // Derive category from subtype if type is missing as a separate field
    // Subtypes are grouped in ranges (0-9: speaking, 10-19: listening, etc.)
    final subtype = quest.subtype?.name ?? '';
    String category = 'speaking';
    if (quest.subtype != null) {
      final index = quest.subtype!.index;
      if (index < 10) {
        category = 'speaking';
      } else if (index < 20) {
        category = 'listening';
      } else if (index < 30) {
        category = 'reading';
      } else if (index < 40) {
        category = 'writing';
      } else if (index < 50) {
        category = 'grammar';
      } else if (index < 60) {
        category = 'vocabulary';
      } else if (index < 70) {
        category = 'accent';
      } else {
        category = 'roleplay';
      }
    }

    final level = quest.difficulty;

    final route = '/game?category=$category&subtype=$subtype&level=$level';

    final result = await context.push(route);

    if (mounted) {
      setState(() => _isLaunching = false);
      if (result == true) {
        setState(() => _currentIndex++);
        if (_currentIndex < widget.quests.length) {
          _startNextGame();
        } else {
          _finishSequence();
        }
      }
    }
  }

  void _finishSequence() {
    Haptics.vibrate(HapticsType.heavy);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        title: Text(
          'Quest Completed!',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
        ),
        content: Text(
          'You finished the $_sequenceTitle! Great work on your training.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              context.pop(); // Back to home
            },
            child: Text(
              'FINISH',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = widget.quests.isEmpty
        ? 1.0
        : _currentIndex / widget.quests.length;

    return Scaffold(
      body: Stack(
        children: [
          const MeshGradientBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      ScaleButton(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.black.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 24.r,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _sequenceTitle.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                            Text(
                              'Part ${_currentIndex + 1} of ${widget.quests.length}',
                              style: GoogleFonts.outfit(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12.h,
                      backgroundColor: isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GlassTile(
                    padding: EdgeInsets.all(32.r),
                    borderRadius: BorderRadius.circular(32.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _currentIndex < widget.quests.length
                              ? widget.quests[_currentIndex].iconData
                              : Icons.check_circle_rounded,
                          size: 64.r,
                          color: const Color(0xFF2563EB),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          _currentIndex < widget.quests.length
                              ? 'UP NEXT'
                              : 'SUMMARY',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _currentIndex < widget.quests.length
                              ? widget.quests[_currentIndex].instruction
                              : 'All parts completed!',
                          style: GoogleFonts.outfit(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            onPressed: _isLaunching ? null : _startNextGame,
                            child: Text(
                              _isLaunching
                                  ? 'LOADING...'
                                  : 'START PART ${_currentIndex + 1}',
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on GameQuest {
  IconData get iconData {
    if (subtype == null) return Icons.auto_awesome_rounded;
    final index = subtype!.index;
    if (index < 10) return Icons.mic_rounded; // Speaking
    if (index < 20) return Icons.hearing_rounded; // Listening
    if (index < 30) return Icons.menu_book_rounded; // Reading
    if (index < 40) return Icons.edit_note_rounded; // Writing
    if (index < 50) return Icons.extension_rounded; // Grammar
    if (index < 60) return Icons.abc_rounded; // Vocabulary
    if (index < 70) return Icons.record_voice_over_rounded; // Accent
    return Icons.forum_rounded; // Roleplay
  }
}
