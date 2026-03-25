import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE9718F), Color(0xFFD88CFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final data = snapshot.data!.data() as Map<String, dynamic>?;

              if (data == null) {
                return const Center(
                  child: Text(
                    "No data found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final partner1 = data['partner1Name'] ?? '';
              final partner2 = data['partner2Name'] ?? '';
              final startDate = (data['startDate'] as Timestamp).toDate();

              final now = DateTime.now();
              final totalDays = now.difference(startDate).inDays;

              final years = now.year - startDate.year;
              final months = now.month - startDate.month;
              final days = now.day - startDate.day;

              // Next anniversary
              final nextAnniversary = DateTime(
                startDate.year + years + 1,
                startDate.month,
                startDate.day,
              );

              final daysToAnniversary = nextAnniversary.difference(now).inDays;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    /// GOOD MORNING
                    const Text(
                      "GOOD MORNING",
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "$partner1 & $partner2",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// BIG DAY COUNTER
                    Center(
                      child: Column(
                        children: [
                          Text(
                            totalDays.toString(),
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "DAYS",
                            style: TextStyle(
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// YEARS / MONTHS / DAYS
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "$years Years, $months Months, $days Days",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "SINCE ${DateFormat('MMMM yyyy').format(startDate)}",
                        style: const TextStyle(
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// NEXT CELEBRATION CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "NEXT CELEBRATION",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "$daysToAnniversary Days to ${years + 1} Years",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// MEMORY OF THE DAY (static for now)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MEMORY OF THE DAY",
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '"The day we finally moved in together. Best decision ever."',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
