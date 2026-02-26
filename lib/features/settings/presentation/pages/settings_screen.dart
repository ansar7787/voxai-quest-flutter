import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voxai_quest/features/settings/presentation/pages/legal_content_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _appVersion = '1.0.0';
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = info.version;
        _buildNumber = info.buildNumber;
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
      body: Stack(
        children: [
          const MeshGradientBackground(),

          // 2. Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, isDark),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 120.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(context, isDark),
                      SizedBox(height: 32.h),
                      _buildSectionTitle('Account'),
                      _buildSettingsGroup(context, isDark, [
                        _buildSettingsTile(
                          context,
                          'Security & Password',
                          Icons.lock_person_rounded,
                          Colors.blue,
                          () => _handlePasswordReset(context),
                        ),
                      ]),

                      SizedBox(height: 32.h),
                      _buildSectionTitle('App Preferences'),
                      _buildSettingsGroup(context, isDark, [
                        _buildSwitchTile(
                          context,
                          'Push Notifications',
                          'Stay updated with daily quests',
                          Icons.notifications_active_rounded,
                          Colors.orange,
                          _notificationsEnabled,
                          (val) => setState(() => _notificationsEnabled = val),
                        ),
                        _buildSettingsTile(
                          context,
                          'Language Selection',
                          Icons.language_rounded,
                          Colors.teal,
                          () => _showComingSoon(context),
                          trailing: Text(
                            'English (US)',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ]),

                      SizedBox(height: 32.h),
                      _buildSectionTitle('Support & Legal'),
                      _buildSettingsGroup(context, isDark, [
                        _buildSettingsTile(
                          context,
                          'Help Center',
                          Icons.help_center_rounded,
                          Colors.green,
                          () => _handleSupportLink(context),
                        ),
                        _buildSettingsTile(
                          context,
                          'Terms of Service',
                          Icons.description_rounded,
                          Colors.blueGrey,
                          () => _handleLegalLink(context, 'Terms of Service'),
                        ),
                        _buildSettingsTile(
                          context,
                          'Privacy Policy',
                          Icons.policy_rounded,
                          Colors.blueGrey,
                          () => _handleLegalLink(context, 'Privacy Policy'),
                        ),
                        _buildSettingsTile(
                          context,
                          'App Version',
                          Icons.info_outline_rounded,
                          Colors.grey,
                          null,
                          trailing: Text(
                            '$_appVersion ($_buildNumber)',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white38 : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),

                      SizedBox(height: 32.h),
                      _buildSectionTitle('Danger Zone'),
                      _buildSettingsGroup(context, isDark, [
                        _buildSettingsTile(
                          context,
                          'Clear App Cache',
                          Icons.cleaning_services_rounded,
                          Colors.amber,
                          () => _handleClearCache(context),
                        ),
                        _buildSettingsTile(
                          context,
                          'Delete Account',
                          Icons.delete_forever_rounded,
                          Colors.red,
                          () => _handleDeleteAccount(context),
                          isDestructive: true,
                        ),
                      ]),

                      SizedBox(height: 40.h),
                      _buildLogoutButton(context, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16.r,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Settings',
        style: GoogleFonts.outfit(
          fontSize: 22.sp,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 12.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 13.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 2.0,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    bool isDark,
    List<Widget> children,
  ) {
    return GlassTile(
      borderRadius: BorderRadius.circular(28.r),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback? onTap, {
    Widget? trailing,
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 20.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDestructive
                        ? Colors.red
                        : (isDark ? Colors.white : const Color(0xFF0F172A)),
                  ),
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.r,
                  color: isDark ? Colors.white24 : Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
    Function(bool) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 20.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    color: isDark ? Colors.white38 : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: (val) {
              Haptics.vibrate(HapticsType.light);
              onChanged(val);
            },
            activeThumbColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withValues(alpha: 0.1),
                  Colors.red.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleLogout(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          size: 18.r,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'SIGN OUT ACCOUNT',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildProfileSection(BuildContext context, bool isDark) {
    final user = context.watch<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

    return GlassTile(
          padding: EdgeInsets.all(24.r),
          borderRadius: BorderRadius.circular(32.r),
          child: Row(
            children: [
              // Avatar with subtle edit indicator
              GestureDetector(
                onTap: () => _showEditProfileDialog(context, user),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.blue.withValues(alpha: 0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 36.r,
                        backgroundColor: const Color(0xFF1E293B),
                        backgroundImage:
                            user.photoUrl != null && user.photoUrl!.isNotEmpty
                            ? NetworkImage(user.photoUrl!)
                            : null,
                        child: user.photoUrl == null || user.photoUrl!.isEmpty
                            ? Icon(
                                Icons.person_rounded,
                                size: 36.r,
                                color: Colors.white24,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.blue.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 10.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? 'Explorer',
                      style: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      user.email,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.blue,
                            size: 12.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            user.isPremium ? 'PREMIUM QUESTER' : 'FREE ACCOUNT',
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  void _showEditProfileDialog(BuildContext context, dynamic user) {
    final TextEditingController nameController = TextEditingController(
      text: user.displayName,
    );
    final ImagePicker picker = ImagePicker();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => Center(
        child: Material(
          color: Colors.transparent,
          child: GlassTile(
            width: 340.w,
            padding: EdgeInsets.all(32.r),
            borderRadius: BorderRadius.circular(40.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Profile Settings',
                  style: GoogleFonts.outfit(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 32.h),
                // Modern Avatar Upload section
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null && context.mounted) {
                      context.read<AuthBloc>().add(
                        AuthUpdateProfilePictureRequested(image.path),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          backgroundImage:
                              user.photoUrl != null && user.photoUrl!.isNotEmpty
                              ? NetworkImage(user.photoUrl!)
                              : null,
                          child: user.photoUrl == null || user.photoUrl!.isEmpty
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 50.r,
                                  color: Colors.white24,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.blue.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                TextField(
                  controller: nameController,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    labelStyle: GoogleFonts.outfit(color: Colors.white38),
                    prefixIcon: Icon(
                      Icons.badge_rounded,
                      color: Colors.blue,
                      size: 20.r,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(color: Colors.white38),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              nameController.text != user.displayName) {
                            context.read<AuthBloc>().add(
                              AuthUpdateDisplayNameRequested(
                                nameController.text,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    Haptics.vibrate(HapticsType.medium);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => Center(
        child: Material(
          color: Colors.transparent,
          child: GlassTile(
            width: 320.w,
            padding: EdgeInsets.all(32.r),
            borderRadius: BorderRadius.circular(40.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.red,
                    size: 40.r,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Sign Out?',
                  style: GoogleFonts.outfit(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Are you sure you want to leave?\nYour quest progress is safely synced to the cloud.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: Colors.white60,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                          context.go(AppRouter.loginRoute);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Yes, Sign Me Out',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: Text(
                          'Stay in Quest',
                          style: GoogleFonts.outfit(
                            color: Colors.white38,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  void _handlePasswordReset(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;

    Haptics.vibrate(HapticsType.medium);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        title: Text(
          'Reset Password',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Send a password recovery email to ${user.email}?',
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                AuthPasswordResetRequested(user.email),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              'Send Link',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSupportLink(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'muhammedansar7787@gmail.com',
      query: encodeQueryParameters({
        'subject': 'Support Request: VoxAI Quest',
        'body':
            'Describe your issue here...\n\nApp Version: $_appVersion\nBuild: $_buildNumber',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  void _handleLegalLink(BuildContext context, String title) {
    String content = '';
    if (title == 'Terms of Service') {
      content = """
TERMS OF SERVICE
Last Updated: February 2026

1. ACCEPTANCE OF TERMS
By accessing and using VoxAI Quest, you agree to be bound by these Terms. If you do not agree to these terms, please do not use the service.

2. DESCRIPTION OF SERVICE
VoxAI Quest is an AI-powered language learning application designed to help users improve their English skills through interactive quests and challenges.

3. USER ACCOUNTS
You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.

4. USER CONDUCT
Users agree to use the service for lawful purposes only and not to engage in any activity that interferes with or disrupts the service.

5. INTELLECTUAL PROPERTY
All content, features, and functionality of VoxAI Quest are the exclusive property of the developer and are protected by international copyright and trademark laws.

6. TERMINATION
We reserve the right to terminate or suspend access to our service immediately, without prior notice or liability, for any reason.

7. LIMITATION OF LIABILITY
In no event shall the developer be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the service.
""";
    } else {
      content = """
PRIVACY POLICY
Last Updated: February 2026

1. INFORMATION WE COLLECT
We collect information you provide directly to us when you create an account,- **Premium Glassmorphic Dialog**: Upgraded the `_showEditProfileDialog` from a standard `AlertDialog` to a custom `showGeneralDialog` with:
    - **Backdrop Blur & Glassmorphism**: Uses the `GlassTile` component for a coherent visual language.
    - **Smooth Animations**: Implemented a scaling and fading entrance animation for a "native" feel.
    - **Enhanced Typography**: Used bolder Outfit fonts and better spacing for a modern look.
    - **Upgraded Inputs**: Redesigned the display name field with a prefix icon, rounded corners, and subtle background fills.
    - **Dramatic Avatar Preview**: The edit dialog now features a larger, more prominent avatar preview with a glowing edit badge and a white-bordered camera icon.

### Profile Card Aesthetic Refinement
Based on follow-up feedback, I have further polished the profile section to remove "heavy" dark borders and improve the edit indicator.

- **Glowing Avatar Border**: Replaced the simple gradient border with a glowing blue effect that feels more "alive".
- **Refined Edit Icon**: Switched the standard "pen" icon to a sleek white-bordered "camera" icon with a subtle shadow, making it clear that it's for profile picture updates.
- **Removed Dark Borders**: Eliminated the dark/black borders around the edit button, opting for a clean, professional look with white accents.
ss. such as your name, email, and profile picture. We also collect data about your progress and interaction with the learning content.

2. HOW WE USE YOUR INFORMATION
We use the information to personalize your learning experience, track your quest progress, manage your rewards (coins/XP), and improve our AI tutors.

3. DATA SECURITY
We implement industry-standard security measures, including Firebase Authentication and Firestore security rules, to protect your personal information from unauthorized access.

4. THIRD-PARTY SERVICES
We use Firebase (Google) for authentication and data storage. Please refer to Google's Privacy Policy for more information on how they handle data.

5. USER RIGHTS
You have the right to access, update, or delete your account data at any time through the in-app settings.

6. CHILDREN'S PRIVACY
VoxAI Quest includes a Kids Zone. We are committed to protecting the privacy of children and comply with COPPA guidelines.

7. CONTACT US
If you have any questions about this Privacy Policy, please contact us at muhammedansar7787@gmail.com.
""";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LegalContentScreen(title: title, content: content),
      ),
    );
  }

  void _handleDeleteAccount(BuildContext context) {
    Haptics.vibrate(HapticsType.heavy);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        title: Text(
          'Danger Zone',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: Colors.red,
          ),
        ),
        content: Text(
          'This action is IRREVERSIBLE. All your progress, coins, and streaks will be permanently deleted.',
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              'Delete Everything',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        title: Text(
          'Final Confirmation',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you absolutely sure? Type "DELETE" to confirm account removal.',
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Abort',
              style: GoogleFonts.outfit(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthDeleteAccountRequested());
              context.go(AppRouter.loginRoute);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              'I am sure',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleClearCache(BuildContext context) async {
    Haptics.vibrate(HapticsType.light);
    try {
      // 1. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 2. Clear Temporary Directory
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cache cleared successfully!',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20.r),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing cache: \$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showComingSoon(
    BuildContext context, {
    String title = "Feature Coming Soon",
    String message =
        "We're working hard to bring this feature to your quest experience!",
  }) {
    Haptics.vibrate(HapticsType.selection);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
          side: const BorderSide(color: Colors.white10),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it!',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
