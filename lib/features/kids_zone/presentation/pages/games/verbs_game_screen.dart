import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_game_base_screen.dart';
import 'package:voxai_quest/features/kids_zone/presentation/bloc/kids_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_image.dart';

class VerbsGameScreen extends StatelessWidget {
  final int level;
  const VerbsGameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return KidsGameBaseScreen(
      title: "Action Verbs",
      gameType: "verbs",
      level: level,
      primaryColor: const Color(0xFF8B5CF6),
      backgroundColors: const [Color(0xFFEDE9FE), Color(0xFFF5F3FF)],
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
            _buildImageCard(quest.imageUrl),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Wrap(
                spacing: 16.r,
                runSpacing: 16.r,
                alignment: WrapAlignment.center,
                children: List.generate(quest.options?.length ?? 0, (index) {
                  final option = quest.options![index];
                  return _buildOptionPill(
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

  Widget _buildImageCard(String? imageUrl) {
    return Container(
      width: 200.r,
      height: 200.r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.r), // Circle for actions
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: KidsImage(
          imageUrl: imageUrl,
          fallbackIcon: Icons.directions_run_rounded,
          iconColor: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildOptionPill(BuildContext context, String text, bool isCorrect) {
    return ScaleButton(
      onTap: () {
        context.read<KidsBloc>().add(SubmitKidsAnswer(isCorrect));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }
}
