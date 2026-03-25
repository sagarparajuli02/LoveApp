import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:love_days/utils/app_colors.dart';
import 'package:love_days/views/events_screen.dart';
import 'package:love_days/views/home_screen.dart';
import 'package:love_days/views/memories_screen.dart';
import 'package:love_days/views/profile_screen.dart';
import 'package:love_days/views/widgets/floating_hearts.dart';

class BottomNavigation extends StatefulWidget {
  final String? initialCoupleId;

  const BottomNavigation({super.key, this.initialCoupleId});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  String? coupleId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final initialCoupleId = widget.initialCoupleId;
    if (initialCoupleId != null && initialCoupleId.isNotEmpty) {
      coupleId = initialCoupleId;
      _isLoading = false;
      return;
    }

    _loadCoupleId();
  }

  Future<void> _loadCoupleId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = doc.data();
      final resolvedCoupleId = _resolveCoupleId(userData);

      if (!mounted) return;
      setState(() {
        coupleId = resolvedCoupleId;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading couple ID: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _resolveCoupleId(Map<String, dynamic>? userData) {
    if (userData == null) return '';

    final inviteCode = userData['inviteCode'];
    if (inviteCode is String && inviteCode.isNotEmpty) {
      return inviteCode;
    }

    final legacyCoupleId = userData['coupleId'];
    if (legacyCoupleId is String && legacyCoupleId.isNotEmpty) {
      return legacyCoupleId;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.appBlack,
        body: Center(
            child:
                CircularProgressIndicator(color: AppColors.accentOrange)),
      );
    }

    // Define screens here to ensure coupleId is available
    final List<Widget> screens = [
      const HomeScreen(), // Ensure HomeScreen has a const constructor
      const MemoryScreen(),
      if ((coupleId ?? '').isNotEmpty)
        EventScreen(coupleId: coupleId!)
      else
        const _MissingCoupleDataScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true, // Crucial for the floating glass effect
      backgroundColor: AppColors.appBlack,
      body: Stack(
        children: [
          /// 🌈 Global Gradient Background (Matches your Home Screen)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.3,
                  colors: [AppColors.plum, AppColors.appBlack],
                ),
              ),
            ),
          ),

          /// 💖 Floating Hearts
          const FloatingHearts(),

          /// 📱 Active Screen with crossfade for smooth transition
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
        ],
      ),
      bottomNavigationBar: _buildPremiumNavBar(),
    );
  }

  Widget _buildPremiumNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.whiteA(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.whiteA(0.12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_rounded, "Home", 0),
                _navItem(Icons.auto_awesome_rounded, "Memories", 1),
                _navItem(Icons.calendar_today_rounded, "Events", 2),
                _navItem(Icons.person_rounded, "Profile", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color activeColor = AppColors.accentOrange;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? activeColor : Colors.white38,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingCoupleDataScreen extends StatelessWidget {
  const _MissingCoupleDataScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Couple data is missing. Please complete setup again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
