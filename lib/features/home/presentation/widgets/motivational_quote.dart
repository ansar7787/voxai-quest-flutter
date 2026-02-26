import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';

class MotivationalQuote extends StatelessWidget {
  const MotivationalQuote({super.key});

  static const List<Map<String, String>> _quotes = [
    {
      'quote': 'The limits of my language mean the limits of my world.',
      'author': 'Ludwig Wittgenstein',
    },
    {
      'quote':
          'Language is the road map of a culture. It tells you where its people come from and where they are going.',
      'author': 'Rita Mae Brown',
    },
    {
      'quote': 'To have another language is to possess a second soul.',
      'author': 'Charlemagne',
    },
    {
      'quote': 'Learning is a treasure that will follow its owner everywhere.',
      'author': 'Chinese Proverb',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quoteData = _quotes[Random().nextInt(_quotes.length)];

    return GlassTile(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: const Color(0xFF2563EB).withValues(alpha: 0.5),
            size: 40.r,
          ),
          SizedBox(height: 12.h),
          Text(
            quoteData['quote']!,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.9)
                  : const Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "— ${quoteData['author']}",
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2563EB),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
