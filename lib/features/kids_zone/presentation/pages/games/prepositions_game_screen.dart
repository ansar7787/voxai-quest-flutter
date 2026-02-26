import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_game_base_screen.dart';
import 'package:voxai_quest/features/kids_zone/presentation/bloc/kids_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_image.dart';

class PrepositionsGameScreen extends StatelessWidget {
  final int level;
  const PrepositionsGameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return KidsGameBaseScreen(
      title: "Prepositions",
      gameType: "prepositions",
      level: level,
      primaryColor: const Color(0xFF64748B),
      backgroundColors: const [Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
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
            _buildIllustration(quest.imageUrl),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Wrap(
                spacing: 20.r,
                runSpacing: 20.r,
                alignment: WrapAlignment.center,
                children: List.generate(quest.options?.length ?? 0, (index) {
                  final option = quest.options![index];
                  return _buildOptionButton(
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

  Widget _buildIllustration(String? imageUrl) {
    return Container(
      width: 280.r,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.black12),
      ),
      padding: EdgeInsets.all(20.r),
      child: KidsImage(
        imageUrl: imageUrl,
        fallbackIcon: Icons.location_on_rounded,
        iconColor: Colors.grey[300],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text, bool isCorrect) {
    return ScaleButton(
      onTap: () {
        context.read<KidsBloc>().add(SubmitKidsAnswer(isCorrect));
      },
      child: Container(
        width: 140.w,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF64748B),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
