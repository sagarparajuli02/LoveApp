import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for HapticFeedback
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_days/views/widgets/mood_selector_sheet.dart';
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
      return const Scaffold(
        backgroundColor: AppColors.appBlack,
        body: Center(
            child: Text("Please login", style: TextStyle(color: Colors.white))),
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
                        style: const TextStyle(
                            color: Colors.white38,
                            letterSpacing: 2,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("$partner1 & $partner2",
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -1)),
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
                                    style: TextStyle(
                                        color: AppColors.accentOrange
                                            .withOpacity(0.9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                if (note.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text("\"$note\"",
                                        style: const TextStyle(
                                            color: Colors.white54,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12)),
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
                        _buildMissingCoupleCard(),

                      const SizedBox(height: 40),
                      _buildHeroCounter(totalDays),
                      const SizedBox(height: 50),
                      const Text("Our Journey",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildStatsGrid(
                          inviteCode, totalDays, memoriesCount, citiesCount),
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
      String inviteCode, int days, int memories, int cities) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _statCard(
            "DAYS TOGETHER", days.toString(), Icons.favorite, Colors.redAccent),
        _statCard("MEMORIES", memories.toString(), Icons.camera_alt,
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
            return _statCard("SPECIAL EVENTS", count.toString(),
                Icons.celebration, Colors.purpleAccent);
          },
        ),
        _statCard("CITIES VISITED", cities.toString(), Icons.location_city,
            Colors.greenAccent),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
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
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildHeroCounter(int totalDays) {
    return Center(
      child: Column(
        children: [
          Text(totalDays.toString(),
              style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
          Text("DAYS TOGETHER",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 4,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
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
                  Text("Mood shared with your partner",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white)),
                ],
              ),
              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.9),
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
                      const Text("Update My Mood",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Let $partnerName know how you are feeling",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissingCoupleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteA(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.whiteA(0.10)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white70),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "We couldn't find your couple link yet. Open setup to finish reconnecting your account.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
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
