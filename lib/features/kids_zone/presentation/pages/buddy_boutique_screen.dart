import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/core/presentation/widgets/ad_reward_card.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_assets.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';

class BuddyBoutiqueScreen extends StatelessWidget {
  const BuddyBoutiqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E3A8A)
          : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          MeshGradientBackground(
            colors: isDark
                ? [
                    const Color(0xFF1E3A8A),
                    const Color(0xFF4F46E5),
                    const Color(0xFF10B981),
                  ]
                : [
                    const Color(0xFFECFDF5),
                    const Color(0xFFDBEAFE),
                    const Color(0xFFFDF2F8),
                  ],
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, isDark),
              _buildBuddyPassportPreview(context, isDark),
              _buildCurrencyHeader(context, isDark),
              _buildShopGrid(context, isDark),
              const SliverToBoxAdapter(child: AdRewardCard()),
              SliverToBoxAdapter(child: SizedBox(height: 50.h)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyPassportPreview(BuildContext context, bool isDark) {
    return SliverToBoxAdapter(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;
          final mascotId = user?.kidsMascot ?? 'owly';
          final accessoryId = user?.kidsEquippedAccessory;

          return Container(
            margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BUDDY PASSPORT",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: isDark ? Colors.white38 : Colors.black26,
                          ),
                        ),
                        Text(
                          "Current Look",
                          style: GoogleFonts.outfit(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.black26,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow Background
                      Container(
                        width: 120.r,
                        height: 120.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF3B82F6).withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Mascot
                      Text(
                        KidsAssets.mascotMap[mascotId] ?? '🦉',
                        style: TextStyle(fontSize: 80.sp),
                      ),
                      // Accessory Overlay
                      if (accessoryId != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              KidsAssets.accessoryMap[accessoryId] ?? '',
                              style: TextStyle(fontSize: 24.sp),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "YOUR BUDDY",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 80.h,
      collapsedHeight: 64.h,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: GlassTile(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          borderRadius: BorderRadius.circular(20.r),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32.r,
                height: 32.r,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18.r,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Buddy Boutique',
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyHeader(BuildContext context, bool isDark) {
    return SliverToBoxAdapter(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final coins = state.user?.kidsCoins ?? 0;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFEF4444).withValues(alpha: 0.2),
                        const Color(0xFFEF4444).withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.toys_rounded,
                    color: const Color(0xFFEF4444),
                    size: 32.r,
                  ),
                ),
                SizedBox(width: 18.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "KIDS COINS",
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFEF4444),
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "$coins",
                        style: GoogleFonts.outfit(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            "CURRENT BALANCE",
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white38 : Colors.black38,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.stars_rounded,
                            size: 10.r,
                            color: const Color(
                              0xFFEF4444,
                            ).withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopGrid(BuildContext context, bool isDark) {
    final items = [
      {
        'id': 'cape_red',
        'name': 'Tiny Cape',
        'price': 50,
        'icon': '🦸',
        'color': Colors.redAccent,
      },
      {
        'id': 'shades_cool',
        'name': 'Cool Shades',
        'price': 30,
        'icon': '🕶️',
        'color': Colors.blueAccent,
      },
      {
        'id': 'wand_magic',
        'name': 'Magic Wand',
        'price': 100,
        'icon': '🪄',
        'color': Colors.purpleAccent,
      },
      {
        'id': 'bell_gold',
        'name': 'Golden Bell',
        'price': 200,
        'icon': '🔔',
        'color': Colors.amber,
      },
      {
        'id': 'hat_explorer',
        'name': 'Explorer Hat',
        'price': 80,
        'icon': '🤠',
        'color': Colors.brown,
      },
      {
        'id': 'wings_star',
        'name': 'Star Wings',
        'price': 500,
        'icon': '🦋',
        'color': Colors.cyanAccent,
      },
    ];

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final owned = user?.kidsOwnedAccessories ?? [];
        final equipped = user?.kidsEquippedAccessory;

        return SliverPadding(
          padding: EdgeInsets.all(24.r),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              final isOwned = owned.contains(item['id']);
              final isEquipped = equipped == item['id'];

              return _buildShopItem(
                context,
                item,
                isDark,
                isOwned: isOwned,
                isEquipped: isEquipped,
              );
            }, childCount: items.length),
          ),
        );
      },
    );
  }

  Widget _buildShopItem(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark, {
    required bool isOwned,
    required bool isEquipped,
  }) {
    return ScaleButton(
      onTap: () => _handleItemAction(context, item, isOwned, isEquipped),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isEquipped
                  ? (item['color'] as Color).withValues(alpha: 0.2)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: isEquipped
                    ? (item['color'] as Color)
                    : (isDark ? Colors.white10 : Colors.white),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['icon'] as String, style: TextStyle(fontSize: 48.sp)),
                SizedBox(height: 12.h),
                Text(
                  item['name'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 8.h),
                if (isEquipped)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "EQUIPPED",
                      style: GoogleFonts.outfit(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: item['color'] as Color,
                      ),
                    ),
                  )
                else if (isOwned)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "EQUIP",
                      style: GoogleFonts.outfit(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.toys_rounded,
                          color: const Color(0xFFEF4444),
                          size: 12.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${item['price']}",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleItemAction(
    BuildContext context,
    Map<String, dynamic> item,
    bool isOwned,
    bool isEquipped,
  ) {
    Haptics.vibrate(HapticsType.selection);
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;
    if (user == null) return;

    if (isEquipped) {
      // Unequip
      authBloc.add(const AuthEquipKidsAccessoryRequested(null));
      return;
    }

    if (isOwned) {
      // Equip
      authBloc.add(AuthEquipKidsAccessoryRequested(item['id'] as String));
      return;
    }

    // Handle Buy
    if (user.kidsCoins < (item['price'] as int)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Not enough Kids Coins! Play more to earn more! 🚀"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    authBloc.add(
      AuthBuyKidsAccessoryRequested(item['id'] as String, item['price'] as int),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You bought ${item['name']}! Awesome! ✨"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}
