import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for HapticFeedback
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_days/views/widgets/mood_selector_sheet.dart';
import 'package:love_days/theme/app_text.dart';
import 'package:love_days/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // --- DYNAMIC GREETING LOGIC ---
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "GOOD MORNING";
    if (hour >= 12 && hour < 17) return "GOOD AFTERNOON";
    return "GOOD EVENING";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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

    return Scaffold(
      backgroundColor: AppColors.appBlack,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white24));
                }

                final userData =
                    userSnapshot.data?.data() as Map<String, dynamic>?;
                if (userData == null) {
                  return const Center(child: Text("No user data found"));
                }

                // --- DATA EXTRACTION ---
                final String partner1 = userData['partner1Name'] ?? 'Partner 1';
                final String partner2 = userData['partner2Name'] ?? 'Partner 2';
                final String inviteCode = _resolveCoupleId(userData);
                final String myRole = userData['userRole'] ?? 'user1';
                final String partnerName =
                    (myRole == 'user1') ? partner2 : partner1;

                final startDate =
                    (userData['startDate'] as Timestamp?)?.toDate() ??
                        DateTime.now();
                final totalDays = DateTime.now().difference(startDate).inDays;

                final int memoriesCount = userData['memoriesCount'] ?? 0;
                final int citiesCount = userData['citiesCount'] ?? 0;

                final bool hasCoupleId = inviteCode.isNotEmpty;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        _getGreeting(),
                        style: context.appText.overline,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$partner1 & $partner2",
                        style: context.appText.heading.copyWith(
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // --- PARTNER MOOD STREAM ---
                      if (hasCoupleId)
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('couples')
                              .doc(inviteCode)
                              .collection('moodstatus')
                              .doc(myRole == 'user1' ? 'user2' : 'user1')
                              .snapshots(),
                          builder: (context, moodSnapshot) {
                            if (!moodSnapshot.hasData) return const SizedBox();
                            final moodData = moodSnapshot.data?.data()
                                as Map<String, dynamic>?;

                            final String status =
                                moodData?['status'] ?? "Feeling Peaceful";
                            final String note = moodData?['note'] ?? "";

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("✨ $partnerName is $status",
                                    style: context.appText.body.copyWith(
                                      color: AppColors.accentOrange
                                          .withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w600,
                                    )),
                                if (note.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text("\"$note\"",
                                        style: context.appText.caption.copyWith(
                                          fontStyle: FontStyle.italic,
                                        )),
                                  ),
                              ],
                            );
                          },
                        ),

                      const SizedBox(height: 24),
                      if (hasCoupleId)
                        _buildMoodSelectorCard(
                            context, inviteCode, myRole, partnerName)
                      else
                        _buildMissingCoupleCard(context),

                      const SizedBox(height: 40),
                      _buildHeroCounter(context, totalDays),
                      const SizedBox(height: 50),
                      Text(
                        "Our Journey",
                        style: context.appText.heading,
                      ),
                      const SizedBox(height: 20),
                      _buildStatsGrid(
                          context,
                          inviteCode,
                          totalDays,
                          memoriesCount,
                          citiesCount),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- GRID COMPONENT ---
  Widget _buildStatsGrid(
      BuildContext context, String inviteCode, int days, int memories, int cities) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _statCard(
            context,
            "DAYS TOGETHER", days.toString(), Icons.favorite, Colors.redAccent),
        _statCard(context, "MEMORIES", memories.toString(), Icons.camera_alt,
            Colors.blueAccent),
        StreamBuilder<QuerySnapshot>(
          stream: inviteCode.isEmpty
              ? null
              : FirebaseFirestore.instance
                  .collection('couples')
                  .doc(inviteCode)
                  .collection('events')
                  .snapshots(),
          builder: (context, snapshot) {
            final int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
            return _statCard(context, "SPECIAL EVENTS", count.toString(),
                Icons.celebration, Colors.purpleAccent);
          },
        ),
        _statCard(context, "CITIES VISITED", cities.toString(), Icons.location_city,
            Colors.greenAccent),
      ],
    );
  }

  Widget _statCard(
      BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteA(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.whiteA(0.05))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: context.appText.subheading.copyWith(
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: context.appText.statLabel),
        ],
      ),
    );
  }

  Widget _buildHeroCounter(BuildContext context, int totalDays) {
    return Center(
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [AppColors.accentOrange, AppColors.heartPink],
              ).createShader(bounds);
            },
            child: Text(
              totalDays.toString(),
              style: context.appText.counter.copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          Text("DAYS TOGETHER",
              style: context.appText.counterLabel),
        ],
      ),
    );
  }

  Widget _buildMoodSelectorCard(BuildContext context, String inviteCode,
      String myRole, String partnerName) {
    return InkWell(
      onTap: () async {
        // 1. Show the sheet and WAIT for it to close
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              MoodSelectorSheet(inviteCode: inviteCode, myRole: myRole),
        );

        // 2. Trigger Haptic Feedback
        HapticFeedback.mediumImpact();

        // 3. Show modern floating SnackBar on the Home Screen
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text("Mood shared with your partner"),
                ],
              ),
              backgroundColor: Colors.deepPurpleAccent.withValues(alpha: 0.9),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.whiteA(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.whiteA(0.10))),
            child: Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: AppColors.moodCardGradient),
                  child: const Icon(Icons.sentiment_satisfied_alt,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Update My Mood",
                        style: context.appText.subheading,
                      ),
                      const SizedBox(height: 4),
                      Text("Let $partnerName know how you are feeling",
                          style: context.appText.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.4),
                          )),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: Colors.white.withValues(alpha: 0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissingCoupleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteA(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.whiteA(0.10)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "We couldn't find your couple link yet. Open setup to finish reconnecting your account.",
              style: context.appText.bodyMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveCoupleId(Map<String, dynamic> userData) {
    final inviteCode = userData['inviteCode'];
    if (inviteCode is String && inviteCode.isNotEmpty) {
      return inviteCode;
    }

    final coupleId = userData['coupleId'];
    if (coupleId is String && coupleId.isNotEmpty) {
      return coupleId;
    }

    return '';
  }

  Widget _buildBackground() {
    return Stack(children: [
      Positioned.fill(
          child: Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.backgroundTopRight))),
      Positioned.fill(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: AppColors.backgroundBottomLeft))),
    ]);
  }
}
