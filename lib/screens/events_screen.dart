import 'dart:ui';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Counting Down",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Upcoming Events",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    _glassCircleWithTextRow(icon: Icons.add, label: "Add")
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Event List
              Expanded(
                child: Stack(
                  children: [
                    /// Heart Background
                    const Positioned(
                      top: 40,
                      left: 50,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white10,
                        size: 60,
                      ),
                    ),
                    const Positioned(
                      top: 200,
                      right: 30,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white10,
                        size: 120,
                      ),
                    ),
                    const Positioned(
                      bottom: 200,
                      left: 20,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white10,
                        size: 50,
                      ),
                    ),

                    /// Scrollable Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 120),
                        children: [
                          _bigEventCard(
                            title: "4th Anniversary",
                            date: "June 12, 2025",
                            icon: Icons.celebration,
                            daysRemaining: 12,
                            hours: 8,
                            minutes: 45,
                          ),
                          const SizedBox(height: 16),
                          _smallEventCard(
                            title: "Trip to Paris",
                            subtitle: "Vacation",
                            icon: Icons.flight_takeoff,
                            remaining: "45 days remaining",
                          ),
                          const SizedBox(height: 12),
                          _smallEventCard(
                            title: "28th Birthday Bash",
                            subtitle: "Sam's Birthday",
                            icon: Icons.cake,
                            remaining: "82 days remaining",
                          ),
                          const SizedBox(height: 12),
                          _smallEventCard(
                            title: "1000 Days Together",
                            subtitle: "Milestone",
                            icon: Icons.home,
                            remaining: "128 days remaining",
                            opacity: 0.8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Big Event Card with countdown
  Widget _bigEventCard({
    required String title,
    required String date,
    required IconData icon,
    required int daysRemaining,
    required int hours,
    required int minutes,
  }) {
    return GestureDetector(
      onTap: () {},
      child: _glassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBox(icon),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4C81).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "In $daysRemaining Days",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _timeColumn(daysRemaining, "Days"),
                    const SizedBox(width: 16),
                    _timeColumn(hours, "Hrs"),
                    const SizedBox(width: 16),
                    _timeColumn(minutes, "Min"),
                  ],
                ),
                _circleArrow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallEventCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String remaining,
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () {},
        child: _glassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 30,
          child: Row(
            children: [
              _iconBox(icon, size: 50, bgOpacity: 0.1),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      remaining,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              _circleArrow(opacity: 0.4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeColumn(int value, String label) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _iconBox(IconData icon, {double size = 48, double bgOpacity = 0.2}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(bgOpacity),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(bgOpacity + 0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: size / 1.5),
    );
  }

  Widget _circleArrow({double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.chevron_right, color: Colors.white38),
      ),
    );
  }

  Widget _glassContainer({
    required Widget child,
    EdgeInsets? padding,
    double borderRadius = 20,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _glassCircleWithTextRow(
      {required IconData icon, required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glassy circle
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10), // space between circle and text
          // Text on the right
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
