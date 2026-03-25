import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "No email available";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF7E9D), Color(0xFFFFB6C1), Color(0xFF9358F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    _glassCircleIcon(Icons.settings),
                  ],
                ),

                const SizedBox(height: 40),

                /// Couple Avatars
                _buildCoupleAvatars(),

                const SizedBox(height: 40),

                /// Info Card
                _glassContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        "Sagar & Riya",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Email: $email", // ✅ Show user email
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _statBox("Memories", "1,420"),
                          const SizedBox(width: 16),
                          _statBox("Events", "84"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// Settings Section
                _glassContainer(
                  child: Column(
                    children: [
                      _settingsItem(Icons.person, "Personal Information"),
                      _divider(),
                      _settingsItem(
                        Icons.notifications,
                        "Shared Notifications",
                      ),
                      _divider(),
                      _settingsItem(Icons.verified_user, "Privacy & Security"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Logout Section
                _glassContainer(
                  child: GestureDetector(
                    onTap: () async {
                      // Sign out logic here
                      await FirebaseAuth.instance.signOut();
                      // Navigate back to AuthScreen
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/auth', // make sure your AuthScreen route is defined
                        (route) => false,
                      );
                    },
                    child: _settingsItem(
                      Icons.logout,
                      "Sign Out",
                      isDestructive: true,
                    ),
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Couple Avatar Section
  Widget _buildCoupleAvatars() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _glassAvatar(
              "https://img.icons8.com/?size=100&id=82402&format=png&color=000000",
            ),
            Transform.translate(
              offset: const Offset(-20, 20),
              child: _glassAvatar(
                "https://img.icons8.com/?size=100&id=80841&format=png&color=000000",
              ),
            ),
          ],
        ),
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Color(0xFFFF4C81),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 24),
        ),
      ],
    );
  }

  Widget _glassAvatar(String image) {
    return Container(
      height: 140,
      width: 140,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
      ),
      child: ClipOval(child: Image.network(image, fit: BoxFit.cover)),
    );
  }

  Widget _statBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsItem(
    IconData icon,
    String title, {
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.redAccent : Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          if (!isDestructive)
            const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.white.withOpacity(0.1));
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _glassCircleIcon(IconData icon) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
