import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_game_base_screen.dart';
import 'package:voxai_quest/features/kids_zone/presentation/bloc/kids_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_image.dart';

class NumbersGameScreen extends StatelessWidget {
  final int level;
  const NumbersGameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return KidsGameBaseScreen(
      title: "Number Fun",
      gameType: "numbers",
      level: level,
      primaryColor: const Color(0xFF0EA5E9),
      backgroundColors: const [Color(0xFFE0F2FE), Color(0xFFF0FDF4)],
      buildGameUI: (context, state) {
        final quest = state.currentQuest;

        return Column(
          children: [
            SizedBox(height: 40.h),
            Text(
              quest.instruction,
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.h),
            _buildGiantNumber(quest.question ?? "?", quest.imageUrl),
            SizedBox(height: 80.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Wrap(
                spacing: 20.r,
                runSpacing: 20.r,
                alignment: WrapAlignment.center,
                children: List.generate(quest.options?.length ?? 0, (index) {
                  final option = quest.options![index];
                  return _buildOptionCircle(
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

  Widget _buildGiantNumber(String number, String? imageUrl) {
    return Container(
      width: 180.r,
      height: 180.r,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? KidsImage(imageUrl: imageUrl, fallbackIcon: Icons.numbers_rounded)
          : Center(
              child: Text(
                number,
                style: GoogleFonts.inter(
                  fontSize: 100.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0EA5E9),
                ),
              ),
            ),
    );
  }

  Widget _buildOptionCircle(BuildContext context, String text, bool isCorrect) {
    return ScaleButton(
      onTap: () {
        context.read<KidsBloc>().add(SubmitKidsAnswer(isCorrect));
      },
      child: Container(
        width: 140.w,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.black12, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ),
    );
  }
}
