import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_days/theme/app_text.dart';
import 'package:love_days/utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _formatCount(int value) {
    // Keep it simple: 1420 -> 1,420
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  String _avatarUrlForSeed(String seed) {
    final encoded = Uri.encodeComponent(seed);
    return "https://api.dicebear.com/7.x/avataaars/png?seed=$encoded";
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.appBlack,
        body: Center(
          child: Text(
            "Please login",
            style: context.appText.body,
          ),
        ),
      );
    }

    final String email = user.email ?? "No email available";

    final userDocStream =
        FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userDocStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppColors.appBlack,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white24),
            ),
          );
        }

        final data = snapshot.data?.data();
        final partner1 = (data?['partner1Name'] as String?)?.trim().isNotEmpty ==
                true
            ? (data?['partner1Name'] as String).trim()
            : 'Partner 1';
        final partner2 = (data?['partner2Name'] as String?)?.trim().isNotEmpty ==
                true
            ? (data?['partner2Name'] as String).trim()
            : 'Partner 2';
        final inviteCode = (data?['inviteCode'] as String?) ?? '';

        final memoriesRaw = data?['memoriesCount'];
        final memoriesCount = (memoriesRaw is num) ? memoriesRaw.toInt() : 0;

        return Scaffold(
          backgroundColor: AppColors.appBlack,
          body: Stack(
            children: [
              // 1. Background Gradients
              _buildBackground(),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile",
                            style: context.appText.heading
                                .copyWith(letterSpacing: -1),
                          ),
                          _glassCircleIcon(Icons.settings, onTap: () {}),
                        ],
                      ),

                      const SizedBox(height: 40),

                      /// Couple Avatar Section
                      _buildCoupleAvatars(
                        partner1Seed: partner1,
                        partner2Seed: partner2,
                      ),

                      const SizedBox(height: 30),

                      /// INFO SECTION
                      Column(
                        children: [
                          Text(
                            "$partner1 & $partner2",
                            style: context.appText.subheading.copyWith(
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: context.appText.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _statBox(
                                context,
                                "Memories",
                                _formatCount(memoriesCount),
                              ),
                              const SizedBox(width: 12),
                              if (inviteCode.isEmpty)
                                _statBox(context, "Events", "0")
                              else
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('couples')
                                      .doc(inviteCode)
                                      .collection('events')
                                      .snapshots(),
                                  builder: (context, eventsSnapshot) {
                                    final count = eventsSnapshot.hasData
                                        ? eventsSnapshot.data!.docs.length
                                        : 0;
                                    return _statBox(
                                      context,
                                      "Events",
                                      _formatCount(count),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      /// MAIN SETTINGS
                      _buildGlassSection([
                        _settingsItem(
                          context,
                          Icons.person_outline,
                          "Edit Information",
                        ),
                        _settingsItem(context, Icons.share_outlined, "Couple Code",
                            trailing: inviteCode.isEmpty
                                ? null
                                : Text(
                                    inviteCode,
                                    style: context.appText.code,
                                  )),
                        _settingsItem(context, Icons.widgets_outlined, "Widgets"),
                        _settingsItem(
                          context,
                          Icons.palette_outlined,
                          "App Theme",
                        ),
                        _settingsItem(
                          context,
                          Icons.auto_awesome_outlined,
                          "Premium Features",
                          trailing: _premiumBadge(context),
                        ),
                      ]),

                      const SizedBox(height: 16),

                      /// EXTRA SETTINGS
                      _buildGlassSection([
                        _settingsItem(context, Icons.info_outline, "About Us"),
                        _settingsItem(
                          context,
                          Icons.shield_outlined,
                          "Privacy & Security",
                        ),
                        _settingsItem(
                          context,
                          Icons.restart_alt_rounded,
                          "Reset App Data",
                        ),
                        _settingsItem(
                          context,
                          Icons.star_outline,
                          "Rate Our App",
                        ),
                      ]),

                      const SizedBox(height: 16),

                      /// LOGOUT
                      _buildGlassSection([
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/auth', (route) => false);
                          },
                          child: _settingsItem(
                            context,
                            Icons.logout_rounded,
                            "Sign Out",
                            isDestructive: true,
                          ),
                        ),
                      ]),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------
  // UI Components
  // ----------------------------

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundTopRight),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundBottomLeft),
          ),
        ),
      ],
    );
  }

  Widget _buildCoupleAvatars({
    required String partner1Seed,
    required String partner2Seed,
  }) {
    return SizedBox(
      height: 160,
      width: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Partner 1
          Positioned(
            left: 0,
            child: _glassAvatar(_avatarUrlForSeed(partner1Seed)),
          ),
          // Partner 2
          Positioned(
            right: 0,
            child: _glassAvatar(_avatarUrlForSeed(partner2Seed)),
          ),
          // Center Heart Glow
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.heartPink,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.heartPink.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _glassAvatar(String url) {
    return Container(
      height: 120,
      width: 120,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.whiteA(0.10)),
        color: AppColors.whiteA(0.05),
      ),
      child: ClipOval(
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _statBox(BuildContext context, String label, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.whiteA(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.whiteA(0.10)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: context.appText.subheading.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                style: context.appText.statLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassSection(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteA(0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.whiteA(0.10)),
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              return Column(
                children: [
                  children[index],
                  if (index != children.length - 1)
                    Divider(
                        height: 1,
                        color: AppColors.whiteA(0.05),
                        indent: 60),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _settingsItem(BuildContext context, IconData icon, String title,
      {bool isDestructive = false, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.redAccent.withValues(alpha: 0.1)
                  : AppColors.whiteA(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: isDestructive ? Colors.redAccent : Colors.white70,
                size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: context.appText.body.copyWith(
                color: isDestructive
                    ? Colors.redAccent
                    : Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing ??
              (isDestructive
                  ? const SizedBox()
                  : Icon(Icons.chevron_right,
                      color: Colors.white.withValues(alpha: 0.2), size: 20)),
        ],
      ),
    );
  }

  Widget _premiumBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentOrange, Colors.orangeAccent],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "PRO",
        style: context.appText.badge,
      ),
    );
  }

  Widget _glassCircleIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteA(0.05),
              border: Border.all(color: AppColors.whiteA(0.10)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
