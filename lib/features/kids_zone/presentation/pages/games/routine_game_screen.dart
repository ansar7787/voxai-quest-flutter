import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_game_base_screen.dart';
import 'package:voxai_quest/features/kids_zone/presentation/bloc/kids_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_image.dart';

class RoutineGameScreen extends StatelessWidget {
  final int level;
  const RoutineGameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return KidsGameBaseScreen(
      title: "My Day",
      gameType: "routine",
      level: level,
      primaryColor: const Color(0xFFF97316),
      backgroundColors: const [Color(0xFFFFEDD5), Color(0xFFFFF7ED)],
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
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quest.options?.length ?? 0,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final option = quest.options![index];
                  return _buildOptionRow(
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

  Widget _buildImageCard(String? imageUrl) {
    return Container(
      width: 240.r,
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF97316).withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: KidsImage(
          imageUrl: imageUrl,
          fallbackIcon: Icons.wb_sunny_rounded,
          iconColor: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildOptionRow(BuildContext context, String text, bool isCorrect) {
    return ScaleButton(
      onTap: () {
        context.read<KidsBloc>().add(SubmitKidsAnswer(isCorrect));
      },
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.black12, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 12.r,
              height: 12.r,
              decoration: const BoxDecoration(
                color: Color(0xFFF97316),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
