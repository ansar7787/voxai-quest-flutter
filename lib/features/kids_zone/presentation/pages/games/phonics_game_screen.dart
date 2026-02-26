import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_game_base_screen.dart';
import 'package:voxai_quest/features/kids_zone/presentation/bloc/kids_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_image.dart';

class PhonicsGameScreen extends StatelessWidget {
  final int level;
  const PhonicsGameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return KidsGameBaseScreen(
      title: "Phonics Fun",
      gameType: "phonics",
      level: level,
      primaryColor: const Color(0xFFFFCC00),
      backgroundColors: const [Color(0xFFFFFBEB), Color(0xFFFFFDF2)],
      buildGameUI: (context, state) {
        final quest = state.currentQuest;

        return Column(
          children: [
            SizedBox(height: 30.h),
            Text(
              quest.instruction,
              style: GoogleFonts.poppins(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            _buildSoundCard(quest.imageUrl, quest.question),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Wrap(
                spacing: 20.r,
                runSpacing: 20.r,
                alignment: WrapAlignment.center,
                children: List.generate(quest.options?.length ?? 0, (index) {
                  final option = quest.options![index];
                  return _buildLetterBubble(
                    context,
                    option,
                    quest.correctAnswer == option,
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSoundCard(String? imageUrl, String? question) {
    return Container(
      width: 220.r,
      height: 220.r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: const Color(0xFFFFCC00), width: 4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFCC00).withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KidsImage(
              imageUrl: imageUrl,
              fallbackIcon: Icons.volume_up_rounded,
              size: 100.r,
              iconColor: const Color(0xFFFFCC00),
            ),
            if (question != null)
              Text(
                question,
                style: GoogleFonts.poppins(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterBubble(BuildContext context, String text, bool isCorrect) {
    return ScaleButton(
      onTap: () {
        context.read<KidsBloc>().add(SubmitKidsAnswer(isCorrect));
      },
      child: Container(
        width: 80.r,
        height: 80.r,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFFFCC00).withValues(alpha: 0.5),
            width: 3,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ),
    );
  }
}
