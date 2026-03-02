import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/utils/payment_service.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final _paymentService = di.sl<PaymentService>();

  @override
  void initState() {
    super.initState();
    _paymentService.init(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onExternalWallet: _handleExternalWallet,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      await _paymentService.upgradeToPremium(user.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Congratulations! You are now a Pro member!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    }
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Immersive Mesh Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        const Color(0xFF0F172A), // Slate 900
                        const Color(0xFF1E1B4B), // Indigo 950
                        const Color(0xFF312E81), // Indigo 900
                      ]
                    : [
                        const Color(0xFFF8FAFC), // Slate 50
                        const Color(0xFFFFF7ED), // Orange 50
                        const Color(0xFFF3E8FF), // Purple 100
                      ],
              ),
            ),
          ),
          // 2. Subtle Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _PremiumPatternPainter(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.05),
              ),
            ),
          ),
          // 3. Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          _buildHeroSection()
                              .animate()
                              .scale(
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fadeIn(),
                          SizedBox(height: 40.h),
                          _buildFeaturesList()
                              .animate(delay: 300.ms)
                              .slideY(begin: 0.1)
                              .fadeIn(),
                          SizedBox(height: 40.h),
                          _buildPriceCard()
                              .animate(delay: 500.ms)
                              .slideY(begin: 0.1)
                              .fadeIn(),
                          SizedBox(height: 120.h), // Spacing for FAB/Button
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 4. Floating CTA
          Positioned(
            bottom: 32.h,
            left: 24.w,
            right: 24.w,
            child: _buildCTAButton()
                .animate(delay: 800.ms)
                .slideY(begin: 1.0)
                .fadeIn(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Haptics.vibrate(HapticsType.selection);
              context.pop();
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.close_rounded,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                size: 24.r,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: const Color(0xFFF59E0B),
                  size: 16.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'PRO MEMBER',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFF59E0B), // Always amber/orange
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
                  width: 140.r,
                  height: 140.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 2.seconds,
                ),
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 50.r,
              ),
            ),
            Positioned(
              top: 0,
              right: 20.r,
              child:
                  Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFCD34D),
                        size: 30.r,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .rotate(begin: -0.1, end: 0.1)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.2, 1.2),
                      ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Text(
          'Unlock the Full Potential',
          style: GoogleFonts.outfit(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF0F172A),
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          'Join thousands of learners achieving fluency faster with VoxAI Quest Pro.',
          style: GoogleFonts.outfit(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : const Color(0xFF64748B),
            fontSize: 16.sp,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFeatureItem(
            Icons.block_rounded,
            'Remove All Ads',
            'No interruptions while learning.',
            Colors.redAccent,
          ),
          Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            height: 32.h,
          ),
          _buildFeatureItem(
            Icons.bolt_rounded,
            '2x Coin Multiplier',
            'Earn double coins on every lesson.',
            Colors.blueAccent,
          ),
          Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            height: 32.h,
          ),
          _buildFeatureItem(
            Icons.card_giftcard_rounded,
            'VIP Daily Gifts',
            'Exclusive rewards every day.',
            Colors.purpleAccent,
          ),
          Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            height: 32.h,
          ),
          _buildFeatureItem(
            Icons.verified_rounded,
            'Pro Badge',
            'Stand out on the leaderboard.',
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(icon, color: color, size: 24.r),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF334155).withValues(alpha: 0.5)
            : const Color(0xFFFFF7ED), // Orange 50
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
              : const Color(0xFFFED7AA),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isDark ? Colors.transparent : const Color(0xFFFFF7ED),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Best Value',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Monthly Pack',
                  style: GoogleFonts.outfit(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹99',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFF59E0B),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '/ 30 Days',
                  style: GoogleFonts.outfit(
                    color: isDark ? Colors.white60 : const Color(0xFF94A3B8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButton() {
    return SizedBox(
          width: double.infinity,
          height: 64.h,
          child: ElevatedButton(
            onPressed: () {
              Haptics.vibrate(HapticsType.heavy);
              final user = context.read<AuthBloc>().state.user;
              if (user != null) {
                _paymentService.purchaseSubscription(
                  contact: '',
                  email: user.email,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF59E0B),
                    Color(0xFFEA580C),
                  ], // Amber to Orange
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFFEA580C).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UPGRADE NOW',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          duration: 3.seconds,
          delay: 1.seconds,
          color: Colors.white.withValues(alpha: 0.3),
        );
  }
}

class _PremiumPatternPainter extends CustomPainter {
  final Color color;
  _PremiumPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double spacing = 40.w;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawCircle(
        Offset(x, x % (spacing * 2) == 0 ? 0 : size.height),
        2,
        paint,
      );
      // Draw diagonal lines
      canvas.drawLine(Offset(x, 0), Offset(x + 20, 20), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
