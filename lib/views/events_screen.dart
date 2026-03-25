import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:love_days/controllers/event_controller.dart';
import 'package:love_days/models/event_model.dart';
import 'package:love_days/views/widgets/add_event_modal.dart';

class EventScreen extends StatelessWidget {
  final String coupleId;

  const EventScreen({super.key, required this.coupleId});

  @override
  Widget build(BuildContext context) {
    final controller = EventController(coupleId);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Gradients & Glows
          _buildBackground(),

          // 2. Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(context, controller),
                const SizedBox(height: 20),

                // 3. Event List Stream
                Expanded(
                  child: StreamBuilder<List<EventModel>>(
                    stream: controller.getEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Colors.white24));
                      }

                      final events = snapshot.data ?? [];
                      if (events.isEmpty) {
                        return const Center(
                          child: Text("No events yet. Click + to add one!",
                              style: TextStyle(color: Colors.white54)),
                        );
                      }

                      // Sorting: closest date first
                      events.sort((a, b) => a.date.compareTo(b.date));

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 100),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _eventCard(
                            event: event,
                            isFirst: index == 0,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Background Design ---
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

  // --- Header ---
  Widget _buildHeader(BuildContext context, EventController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Celebrate Every Moment",
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5)),
              SizedBox(height: 4),
              Text("Special Events",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1)),
            ],
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddEventModal(controller: controller),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }

  // --- Glass Event Card ---
  Widget _eventCard({
    required EventModel event,
    required bool isFirst,
  }) {
    // Determine Accent Color (Used for the background of the icon and glow)
    Color accentColor;
    switch (event.icon) {
      case 'birthday':
        accentColor = Colors.pinkAccent;
        break;
      case 'ring':
        accentColor = const Color(0xFFec5b13);
        break;
      case 'plane':
        accentColor = Colors.blueAccent;
        break;
      case 'gift':
        accentColor = Colors.purpleAccent;
        break;
      default:
        accentColor = Colors.indigoAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: isFirst
            ? [
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 25,
                  spreadRadius: -5,
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(12), // Adjust for icon size
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: Image.asset(
                    'assets/icons/${event.icon}.png',
                    fit: BoxFit.contain,
                    // "color: null" or removing the color property ensures
                    // the PNG keeps its default colors and style.
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateWithSuffix(event.date),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Countdown
                Text(
                  _getCountdownText(event.date),
                  style: TextStyle(
                    color: isFirst ? accentColor : Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Logic Helpers ---

  String _formatDateWithSuffix(DateTime date) {
    final day = date.day;
    String suffix = 'th';
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    // Returns e.g., "October 24th, 2026"
    return "${DateFormat('MMMM d').format(date)}$suffix, ${DateFormat('y').format(date)}";
  }

  String _getCountdownText(DateTime eventDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(eventDate.year, eventDate.month, eventDate.day);
    final difference = target.difference(today).inDays;

    if (difference == 0) return "Today";
    if (difference < 0) return "${difference.abs()} days ago";
    return "In $difference days";
  }
}
