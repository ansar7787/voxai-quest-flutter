import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/animated_kids_asset.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_assets.dart';

class MascotSelectionScreen extends StatelessWidget {
  const MascotSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MeshGradientBackground(
            colors: [Color(0xFFE0F2FE), Color(0xFFF0FDF4), Color(0xFFFFF7ED)],
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                SizedBox(height: 20.h),
                Text(
                  "Choose Your Buddy!",
                  style: GoogleFonts.poppins(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  "Which friend will join your quest?",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      child: Wrap(
                        spacing: 20.w,
                        runSpacing: 30.h,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildMascotCard(
                            context,
                            "owly",
                            "Owly",
                            "Wise and Helpful",
                            Colors.indigo,
                            "assets/lottie/kids/owl_buddy.json",
                          ),
                          _buildMascotCard(
                            context,
                            "foxie",
                            "Foxie",
                            "Playful and Fast",
                            Colors.orange,
                            "assets/lottie/kids/fox_buddy.json",
                          ),
                          _buildMascotCard(
                            context,
                            "dino",
                            "Dino",
                            "Strong and Brave",
                            Colors.green,
                            "assets/lottie/kids/dino_buddy.json",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        children: [
          ScaleButton(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded, size: 28.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotCard(
    BuildContext context,
    String id,
    String name,
    String trait,
    Color color,
    String lottiePath,
  ) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isSelected = state.user?.kidsMascot == id;
        return ScaleButton(
          onTap: () {
            context.read<AuthBloc>().add(AuthUpdateKidsMascotRequested(id));
            _showSuccessOverlay(context, name);
          },
          child: Container(
            width: 160.w,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 4.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: 0.3)
                      : Colors.black12,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 120.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: KidsAssets.mascotMap.containsKey(id)
                      ? Center(
                          child: AnimatedKidsAsset(
                            emoji: KidsAssets.mascotMap[id]!,
                            size: 80.r,
                            animation: KidsAssetAnimation.hover,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                SizedBox(height: 12.h),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  trait,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black38,
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(height: 8.h),
                  Icon(Icons.check_circle_rounded, color: color, size: 24.r),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessOverlay(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$name is now your buddy!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
