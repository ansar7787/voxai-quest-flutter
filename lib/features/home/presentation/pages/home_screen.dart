import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/home/presentation/widgets/bento_arena.dart';
import 'package:voxai_quest/features/home/presentation/widgets/category_shelf.dart';
import 'package:voxai_quest/features/home/presentation/widgets/command_pod.dart';
import 'package:voxai_quest/features/home/presentation/widgets/discovery_deck.dart';
import 'package:voxai_quest/features/home/presentation/widgets/motivational_quote.dart';
import 'package:voxai_quest/features/home/presentation/widgets/mystery_chest_overlay.dart';
import 'package:voxai_quest/core/presentation/widgets/ad_reward_card.dart';

import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_reward_ad_card.dart';
import 'package:voxai_quest/features/home/presentation/widgets/voxin_mascot_card.dart';
import 'package:voxai_quest/core/presentation/widgets/banner_ad_widget.dart';
import 'package:voxai_quest/features/home/presentation/widgets/daily_spin_card.dart';
import 'package:voxai_quest/features/home/presentation/widgets/daily_mystery_spin_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showChest = true;
  bool _showSpinWheel = false;
  bool _chestOpened = false;
  int _rewardAmount = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _checkDailyChest();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _checkDailyChest() async {
    if (!mounted) return;
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;

    final lastReward = user.lastDailyRewardDate;
    if (lastReward != null) {
      final now = DateTime.now();
      final isSameDay =
          now.year == lastReward.year &&
          now.month == lastReward.month &&
          now.day == lastReward.day;

      if (isSameDay) {
        if (mounted) {
          setState(() => _showChest = false);
        }
      }
    }
  }

  Future<void> _openChest() async {
    Haptics.vibrate(HapticsType.heavy);
    if (!mounted) return;
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      // 1 to 50 coins as requested
      final int totalCoins = Random().nextInt(50) + 1;

      setState(() {
        _chestOpened = true;
        _rewardAmount = totalCoins;
      });
      _confettiController.play();

      context.read<AuthBloc>().add(AuthClaimDailyChestRequested(totalCoins));

      // Store the collected amount for the UI (can be passed to MysteryChestOverlay if needed)
      // For now, let's just use it in the confetti delay

      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() => _showChest = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) return const HomeShimmerLoading();

          return Stack(
            children: [
              const MeshGradientBackground(),
              RefreshIndicator(
                onRefresh: () async {
                  context.read<AuthBloc>().add(AuthReloadUser());
                  await Future.delayed(const Duration(milliseconds: 400));
                },
                color: const Color(0xFF2563EB),
                displacement: 40.h,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Adaptive Command Pod
                    SliverToBoxAdapter(child: CommandPod(user: user)),

                    // Voxin Companion (2026 Redesign)
                    const SliverToBoxAdapter(child: VoxinMascotCard()),

                    // Discovery Hub
                    _buildSliverSectionHeader(
                      context,
                      'Discovery Hub',
                      '10 immersive audio experiences',
                    ),
                    SliverToBoxAdapter(
                      child: DiscoveryDeck(
                        user: user,
                        onLaunchQuest: (id) => _launchThemedQuest(context, id),
                      ),
                    ),

                    // Study Shelves - Area 1: Production
                    _buildSliverSectionHeader(
                      context,
                      'Speaking Mastery',
                      '10 vocal challenges for fluency',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=speaking',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.speaking.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    _buildSliverSectionHeader(
                      context,
                      'Writing Studio',
                      '10 ways to craft perfect text',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=writing',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.writing.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    // Study Shelves - Area 2: Comprehension
                    _buildSliverSectionHeader(
                      context,
                      'Reading Foundations',
                      '10 quests for speed & insight',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=reading',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.reading.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    _buildSliverSectionHeader(
                      context,
                      'Listening Lab',
                      '10 scenarios for real-world practice',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=listening',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.listening.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    // Study Shelves - Area 3: Knowledge
                    _buildSliverSectionHeader(
                      context,
                      'Vocabulary Vault',
                      '10 games to expand your lexicon',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=vocabulary',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.vocabulary.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    _buildSliverSectionHeader(
                      context,
                      'Grammar Hub',
                      '10 rules for structural mastery',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=grammar',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.grammar.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    // Study Shelves - Area 4: Nuance
                    _buildSliverSectionHeader(
                      context,
                      'Accent Academy',
                      '10 drills for natural pronunciation',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=accent',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.accent.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    _buildSliverSectionHeader(
                      context,
                      'Roleplay Realm',
                      '10 immersive situational scenarios',
                      onSeeAll: () => context.push(
                        '${AppRouter.categoryGamesRoute}?category=roleplay',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoryShelf(
                        user: user,
                        subtypes: QuestType.roleplay.subtypes
                            .where((s) => !s.isLegacy)
                            .toList(),
                      ),
                    ),

                    // Quest Arena (Bento)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 48.h),
                            BentoArena(user: user),
                          ],
                        ),
                      ),
                    ),

                    // Mastery Stats & Quote
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(height: 48.h),
                          SizedBox(height: 48.h),
                          const MotivationalQuote(),
                          SizedBox(height: 32.h),
                          DailySpinCard(
                            onTap: () {
                              setState(() {
                                _showSpinWheel = true;
                              });
                            },
                          ),
                          SizedBox(height: 32.h),
                          const AdRewardCard(margin: EdgeInsets.zero),
                          SizedBox(height: 16.h),
                          const KidsRewardAdCard(),
                          SizedBox(height: 32.h),
                          const BannerAdWidget(),
                          SizedBox(height: 120.h),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showChest)
                MysteryChestOverlay(
                  isOpened: _chestOpened,
                  rewardAmount: _rewardAmount,
                  onOpen: _openChest,
                  confettiController: _confettiController,
                ),
              if (_showSpinWheel)
                DailyMysterySpinOverlay(
                  onClose: () {
                    setState(() {
                      _showSpinWheel = false;
                    });
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverSectionHeader(
    BuildContext context,
    String title,
    String subtitle, {
    VoidCallback? onSeeAll,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            SizedBox(height: 32.h),
            _buildSectionHeader(context, title, subtitle, onSeeAll: onSeeAll),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle, {
    VoidCallback? onSeeAll,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white38 : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        if (onSeeAll != null)
          ScaleButton(
            onTap: onSeeAll,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'SEE ALL',
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2563EB),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _launchThemedQuest(BuildContext context, String questId) {
    Haptics.vibrate(HapticsType.medium);
    context.push('${AppRouter.questSequenceRoute}?id=$questId');
  }
}
