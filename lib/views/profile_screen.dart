import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Color primaryPink = const Color(0xFF831843);
  final Color accentOrange = const Color(0xFFec5b13);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "No email available";

    return Scaffold(
      backgroundColor: Colors.black,
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
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      _glassCircleIcon(Icons.settings, onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// Couple Avatar Section
                  _buildCoupleAvatars(),

                  const SizedBox(height: 30),

                  /// INFO SECTION
                  Column(
                    children: [
                      const Text(
                        "Sagar & Riya",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _statBox("Memories", "1,420"),
                          const SizedBox(width: 12),
                          _statBox("Events", "84"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// MAIN SETTINGS
                  _buildGlassSection([
                    _settingsItem(Icons.person_outline, "Edit Information"),
                    _settingsItem(Icons.share_outlined, "Couple Code"),
                    _settingsItem(Icons.widgets_outlined, "Widgets"),
                    _settingsItem(Icons.palette_outlined, "App Theme"),
                    _settingsItem(
                        Icons.auto_awesome_outlined, "Premium Features",
                        trailing: _premiumBadge()),
                  ]),

                  const SizedBox(height: 16),

                  /// EXTRA SETTINGS
                  _buildGlassSection([
                    _settingsItem(Icons.info_outline, "About Us"),
                    _settingsItem(Icons.shield_outlined, "Privacy & Security"),
                    _settingsItem(Icons.restart_alt_rounded, "Reset App Data"),
                    _settingsItem(Icons.star_outline, "Rate Our App"),
                  ]),

                  const SizedBox(height: 16),

                  /// LOGOUT
                  _buildGlassSection([
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/auth', (route) => false);
                      },
                      child: _settingsItem(
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
  }

  // ----------------------------
  // UI Components
  // ----------------------------

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.3,
                colors: [Color(0xFF3b0764), Colors.black],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomLeft,
                radius: 1.2,
                colors: [Color(0xFF831843), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoupleAvatars() {
    return SizedBox(
      height: 160,
      width: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Partner 1
          Positioned(
            left: 0,
            child: _glassAvatar(
                "https://api.dicebear.com/7.x/avataaars/png?seed=Sagar"),
          ),
          // Partner 2
          Positioned(
            right: 0,
            child: _glassAvatar(
                "https://api.dicebear.com/7.x/avataaars/png?seed=Riya"),
          ),
          // Center Heart Glow
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4C81),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4C81).withOpacity(0.4),
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
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        color: Colors.white.withOpacity(0.05),
      ),
      child: ClipOval(
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
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
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              return Column(
                children: [
                  children[index],
                  if (index != children.length - 1)
                    Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                        indent: 60),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _settingsItem(IconData icon, String title,
      {bool isDestructive = false, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.redAccent.withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
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
              style: TextStyle(
                color: isDestructive
                    ? Colors.redAccent
                    : Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          trailing ??
              (isDestructive
                  ? const SizedBox()
                  : Icon(Icons.chevron_right,
                      color: Colors.white.withOpacity(0.2), size: 20)),
        ],
      ),
    );
  }

  Widget _premiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [accentOrange, Colors.orangeAccent]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text("PRO",
          style: TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
