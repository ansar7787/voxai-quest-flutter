import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_game_base_screen.dart';
import 'package:voxai_quest/features/kids_zone/presentation/bloc/kids_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_image.dart';

class TimeGameScreen extends StatelessWidget {
  final int level;
  const TimeGameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return KidsGameBaseScreen(
      title: "Tell the Time",
      gameType: "time",
      level: level,
      primaryColor: const Color(0xFF333333),
      backgroundColors: const [Color(0xFFF3F4F6), Color(0xFFF9FAFB)],
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
            _buildClockFace(quest.imageUrl),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.r,
                  mainAxisSpacing: 16.r,
                  childAspectRatio: 2.0,
                ),
                itemCount: quest.options?.length ?? 0,
                itemBuilder: (context, index) {
                  final option = quest.options![index];
                  return _buildTimeCard(
                    context,
                    option,
                    quest.correctAnswer == option,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClockFace(String? imageUrl) {
    return Container(
      width: 220.r,
      height: 220.r,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF333333), width: 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: KidsImage(
        imageUrl: imageUrl,
        fallbackIcon: Icons.access_time_filled_rounded,
        iconColor: Colors.grey[300],
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, String text, bool isCorrect) {
    return ScaleButton(
      onTap: () {
        context.read<KidsBloc>().add(SubmitKidsAnswer(isCorrect));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
